Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbaJ1L4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:56:15 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:56475 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbaJ1L4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:56:05 -0400
MIME-Version: 1.0
In-Reply-To: <20141028113531.GZ12379@n2100.arm.linux.org.uk>
References: <1414407950-3029-1-git-send-email-m.szyprowski@samsung.com>
	<1414407950-3029-5-git-send-email-m.szyprowski@samsung.com>
	<20141027111404.GW12379@n2100.arm.linux.org.uk>
	<544E2A46.7070106@samsung.com>
	<20141028113531.GZ12379@n2100.arm.linux.org.uk>
Date: Tue, 28 Oct 2014 09:50:13 -0200
Message-ID: <CAOMZO5Ddp1=4K6qNmLxi-=TKmEFDm5B+7XRLkemrYMCPzZAjJw@mail.gmail.com>
Subject: Re: [PATCH v6 4/7] ARM: l2c: Add support for overriding prefetch settings
From: Fabio Estevam <festevam@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, loeliger@gmail.com,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        drake@endlessm.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 9:35 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:

> Ok.
>
> I'd ask for one change.  Please make all these messages start with
> "L2C-310 OF" not "PL310 OF:".  The device is described in ARM
> documentation as a L2C-310 not PL310.  (Also note the : is dropped
> too - most of the other messages don't have the : either.)
>
> The:
>
> "PL310 OF: cache setting yield illegal associativity
> PL310 OF: -1073346556 calculated, only 8 and 16 legal"

I have sent a patch to address this error message that happens when
"cache-size" and "cache-sets" properties are not passed in DT:
http://www.spinics.net/lists/arm-kernel/msg372094.html
