Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbaAULWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 06:22:32 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54556 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754042AbaAULWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:22:30 -0500
Date: Tue, 21 Jan 2014 11:21:55 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: libunwind-devel <libunwind-devel@nongnu.org>, Jiri Olsa <jolsa@redhat.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] Add support for dwarf compat mode unwinding
Message-ID: <20140121112155.GI30706@mudshark.cambridge.arm.com>
References: <1390252922-25889-1-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390252922-25889-1-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 09:21:59PM +0000, Jean Pihet wrote:
> In the case of unwinding the debug info from a binary that has a different
> address size than the current native platform, it is needed to record
> it in the address space struct, in order to correctly parse the debug
> info later. This mode is known as compat mode.

Terminology issues here.... compat mode isn't really that well defined, but
typically involves a different kernel ABI. That doesn't necessarily affect
the address size.

> This is the case when e.g. profiling an ARMv7 binary that runs on an
> ARMv8 (aka AARCH64) platform.

ARMv8 != AArch64

Will
