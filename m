Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaBLKK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:10:58 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40731 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752220AbaBLKKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:10:54 -0500
Date: Wed, 12 Feb 2014 10:10:11 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnaldo <acme@ghostprotocols.net>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Patch Tracking <patches@linaro.org>
Subject: Re: [PATCH] perf: ARM64: wire up perf_regs and unwind support
Message-ID: <20140212101011.GC13441@mudshark.cambridge.arm.com>
References: <1391451427-31221-1-git-send-email-jean.pihet@linaro.org>
 <CAFrcx1kApRNN7aKQr89Y51w_JqUhVZ2x4+a8Sx8-X7xb-a1=pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1kApRNN7aKQr89Y51w_JqUhVZ2x4+a8Sx8-X7xb-a1=pw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 08:46:38AM +0000, Jean Pihet wrote:
> Hi Arnaldo, Will,
> 
> Ping on this patch.

This needs to go via the perf tree to avoid a repeat of the mess last time.

Will
