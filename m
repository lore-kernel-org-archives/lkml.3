Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbbAEEFQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 23:05:16 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:53091 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbbAEEFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 23:05:14 -0500
From: jitendra kumar khasdev <jkhasdev@gmail.com>
X-Google-Original-From: jitendra kumar khasdev <jittu@gmail.com>
Date: Mon, 5 Jan 2015 09:34:57 +0530 (IST)
X-X-Sender: jittu@jitendra
To: Greg KH <gregkh@linuxfoundation.org>
cc: jitendra kumar khasdev <jkhasdev@gmail.com>, abbotti@mev.co.uk,
        hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        pankaj.saraf@nektech.in, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Staging: comedi: fix line over 80 characters
 warning
In-Reply-To: <20150104234152.GA14138@kroah.com>
Message-ID: <alpine.DEB.2.10.1501050934180.3526@jitendra>
References: <1420289195-5012-1-git-send-email-jkhasdev@gmail.com> <20150104234152.GA14138@kroah.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-281382990-1420430713=:3526"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-281382990-1420430713=:3526
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Hello,
Will I have to resubmit by combining all 5 into 1 patch? Please give me 
suggestion  so that I can do it in correct way.

Regards,
Jitendra


Regards,
Jitendra Kumar Khasdev,
CSE-Student | GGITM
jkhasdev@gmail.com| Mo.8435260882

On Sun, 4 Jan 2015, Greg KH wrote:

> On Sat, Jan 03, 2015 at 06:16:31PM +0530, jitendra kumar khasdev wrote:
> > This is patch to file pcl812.c that fix up warning line
> > over 80 character which is found by checkpatch tool.
> > 
> > Signed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
> > ---
> >  drivers/staging/comedi/drivers/pcl812.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> There are 5 patches here all with the identical subject line, which I
> can't accept for the obvious reason that they must be all doing the same
> exact thing, which would be pointless, right?  :)
> 
> thanks,
> 
> greg k-h
> 
--8323329-281382990-1420430713=:3526--
