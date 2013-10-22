Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab3JVJGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 05:06:00 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63052 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3JVJF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 05:05:58 -0400
Date: Tue, 22 Oct 2013 10:05:52 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jan =?iso-8859-1?Q?L=FCbbe?= <jlu@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] typo fixes (coordiante -> coordinate) in am335x
Message-ID: <20131022090552.GE19112@lee--X1>
References: <1373901928-19605-1-git-send-email-zubair.lutfullah@gmail.com>
 <20130821075828.GZ7656@atomide.com>
 <1382198544.22609.8.camel@polaris.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1382198544.22609.8.camel@polaris.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Oct 2013, Jan Lübbe wrote:

> On Wed, 2013-08-21 at 00:58 -0700, Tony Lindgren wrote:
> > * Zubair Lutfullah <zubair.lutfullah@gmail.com> [130715 08:33]:
> > > Did a grep for coordiante and replaced them all
> > > with coordinate.
> > > 
> > > This applies to the mfd-next tree.
> > 
> > This should be safe to apply via the MFD tree as a non-critical
> > fix assuming the bootloaders are not yet using this:
> > 
> > Acked-by: Tony Lindgren <tony@atomide.com>
> 
> It seems this didn't get applied. It fixes the touchscreen on a
> BeagleBone black with the 7" LCD and we should avoid having people use
> the wrong binding.
> 
> Samuel or Lee: Could you take this patch?

This is the first time this patch has been sent to me.

I need Dmitry's input (no pun intended) on how he's like to deal with
this. At a bare minimum I'd like his Ack.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
