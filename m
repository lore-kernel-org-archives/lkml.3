Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbaGIOFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:05:21 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40286 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756274AbaGIOFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:05:19 -0400
Date: Wed, 9 Jul 2014 15:04:28 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>
Subject: Re: [PATCH 0/3] ARM: perf: allow tracing with kernel tracepoints
 events
Message-ID: <20140709140427.GP9485@arm.com>
References: <1404740710-14691-1-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404740710-14691-1-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Mon, Jul 07, 2014 at 02:45:07PM +0100, Jean Pihet wrote:
> - Robustify the user backtrace code, as done on other architectures.
> - Provide the symbols resolution when triggering from tracepoints.
> 
> Big thanks to Steve Capper for the help in debugging and rephrasing the
> commits descriptions.
> 
> Stress tested with perf record and tracepoints triggering (-e <tracepoint>),
> with unwinding using fp (--call-graph fp) and dwarf info (--call-graph dwarf).

I've taken the first two in this series, but patch 3 still doesn't address
my concerns about saving the required register state for unwinding.

Thanks!

Will
