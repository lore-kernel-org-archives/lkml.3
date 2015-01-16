Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbbAPQ7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:59:17 -0500
Received: from down.free-electrons.com ([37.187.137.238]:35809 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752118AbbAPQ7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:59:15 -0500
Date: Fri, 16 Jan 2015 17:59:14 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sylvain Rochet <sylvain.rochet@finsecur.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clockevents: don't suspend/resume if unused
Message-ID: <20150116165914.GS3843@piout.net>
References: <1421399151-26800-1-git-send-email-alexandre.belloni@free-electrons.com>
 <20150116092014.GA27945@gradator.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150116092014.GA27945@gradator.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 16/01/2015 at 10:20:14 +0100, Sylvain Rochet wrote :
> > +		if (dev->suspend && dev->mode != CLOCK_EVT_MODE_UNUSED)
> 
> I wonder if we should use > CLOCK_EVT_MODE_SHUTDOWN
> (or CLOCK_EVT_MODE_UNUSED || CLOCK_EVT_MODE_SHUTDOWN) instead of 
> !CLOCK_EVT_MODE_UNUSED.
> 

I'll let Thomas or Daniel decide :) But I'm open to that.

>-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
