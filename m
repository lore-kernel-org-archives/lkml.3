Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbaI2MfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:35:22 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:49202 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbaI2MfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:35:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Felipe Balbi <balbi@ti.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB changes for v3.18 merge window
Date: Mon, 29 Sep 2014 15:35:22 +0300
Message-ID: <4470421.xsts97VC3x@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <CAMuHMdX9mSv0H-fS23KKONO+=aiCtZ5fxZBvbBnhCev3DffkCQ@mail.gmail.com>
References: <1410976602-1536-1-git-send-email-balbi@ti.com> <CAMuHMdX9mSv0H-fS23KKONO+=aiCtZ5fxZBvbBnhCev3DffkCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Monday 29 September 2014 11:31:30 Geert Uytterhoeven wrote:
> On Wed, Sep 17, 2014 at 7:56 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Andrzej Pietrasiewicz (23):
> >       usb: gadget: uvc: rename functions to avoid conflicts with host uvc
> 
> It seems not everything got renamed:
> 
> drivers/usb/gadget/function/uvc_v4l2.c:363:23: error:
> 'uvcg_v4l2_get_unmapped_area' undeclared here (not in a function)
> make[5]: *** [drivers/usb/gadget/function/uvc_v4l2.o] Error 1
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/12028115/

Indeed :-/ I should have caught that, my bad.

Arnd has sent a patch to fix the problem, I've asked Felipe to apply it.

-- 
Regards,

Laurent Pinchart

