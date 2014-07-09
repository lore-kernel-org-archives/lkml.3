Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbaGIJ5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:57:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35923 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313AbaGIJ5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:57:11 -0400
Date: Wed, 9 Jul 2014 10:57:18 +0100
From: Will Deacon <will.deacon@arm.com>
To: "behanw@converseincode.com" <behanw@converseincode.com>
Cc: "anurag19aggarwal@gmail.com" <anurag19aggarwal@gmail.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "charlebm@gmail.com" <charlebm@gmail.com>,
        "dave.long@linaro.org" <dave.long@linaro.org>,
        "k.khlebnikov@samsung.com" <k.khlebnikov@samsung.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linyongting@gmail.com" <linyongting@gmail.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rabin@rab.in" <rabin@rab.in>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [PATCH 0/6] LLVMLinux: Patches to enable the kernel to be
 compiled with clang/LLVM
Message-ID: <20140709095718.GD9485@arm.com>
References: <1404850576-2006-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404850576-2006-1-git-send-email-behanw@converseincode.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 09:16:10PM +0100, behanw@converseincode.com wrote:
> From: Behan Webster <behanw@converseincode.com>
> 
> The LLVMLinux project aims to fully build the Linux kernel using both gcc and
> clang (the C front end for the LLVM compiler infrastructure project). 
> 
> Clang only supports global named registers for non-allocatable registers like
> the stack pointer. By centralizing the definition of current_stack_pointer, the
> use of named registers for ARM remains largely unchanged while working for both
> gcc and clang.

All looks sane to me. For the series:

  Acked-by: Will Deacon <will.deacon@arm.com>

BTW, have you tried building an arm64 kernel with clang?

Will
