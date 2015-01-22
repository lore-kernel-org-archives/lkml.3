Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbbAVK4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:56:20 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:51820 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbbAVK4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:56:11 -0500
Date: Thu, 22 Jan 2015 10:56:05 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH RESEND v2 3/7] mfd: cros_ec: Add cros_ec_lpc driver for
 x86 devices
Message-ID: <20150122105605.GB9129@x1>
References: <1420205572-2640-1-git-send-email-javier.martinez@collabora.co.uk>
 <1420205572-2640-4-git-send-email-javier.martinez@collabora.co.uk>
 <20150120081104.GT21886@x1>
 <54BE7B08.1010900@collabora.co.uk>
 <20150120163410.GC30656@x1>
 <54BE87C4.4040108@collabora.co.uk>
 <20150122084244.GP22024@x1>
 <54C0BE21.7020008@collabora.co.uk>
 <20150122094608.GA5769@x1>
 <54C0D29C.4010904@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54C0D29C.4010904@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Javier Martinez Canillas wrote:
> On 01/22/2015 10:46 AM, Lee Jones wrote:
> >> 
> >> But there doesn't seem to be a LPC subsystem in the kernel so we don't have a
> >> nice abstraction layer in this case.
> > 
> > This is the crux of the problem.  However, I feel bad for MFD, as it
> > is, once more, being used as an "well it doesn't fit anywhere else, so
> > let's shoehorn it in there" type of dumping ground.
> >
> Yes, I completely understand your point, is that I didn't think that a ~300
> lines driver was that bad specially since the communication bits that reads
> and writes the register is not a complex logic IMHO.

This has nothing to do with LoC, it's the principle of the matter.

> >> > Are there any other Low Pin Count drivers in the kernel?
> >> >
> >> 
> >> I don't know tbh, I didn't even know what LPC was before I picked this patch
> >> to push it upstream. I searched in the Linux codebase for other LPC drivers
> >> but I didn't find anything, that doesn't mean that it doesn't exist though.
> > 
> > I agree.  Perhaps a suitable driver should live in drivers/misc until
> > there are enough of them to warrant its own subsystem.
> >
> 
> Yes, I can move the driver to drivers/misc if you think that is more suitable
> to be there.
> 
> I've taken another look and AFAICT there are two other mfd drivers that use an
> LPC bus, these are drivers/mfd/lpc_{i,s}ch.c for Intel's I/O Controller HUB and 
> System Controller Hub respectively.

These looked like PCI aggregates when I looked at them last?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
