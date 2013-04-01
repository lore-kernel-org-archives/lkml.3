Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404Ab3DAVJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 17:09:58 -0400
Received: from mout.gmx.net ([212.227.15.19]:54935 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757906Ab3DAVJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 17:09:57 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18SgE99HvISqErjOdY9w01gt65ccBsOLW+aLQm5P8
	fIBvEBAcEhHBWp
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: peterasplund@gentoo.se, Kent Yoder <shpedoikal@gmail.com>
Subject: Re: [tpmdd-devel] tpm_tis driver failed to suspend, error -62
Date: Mon, 1 Apr 2013 23:12:09 +0200
User-Agent: KMail/1.13.7 (Linux/3.8.4; KDE/4.9.5; x86_64; ; )
Cc: tpmdd-devel@lists.sourceforge.net, Peter.Huewe@infineon.com,
        mail@srajiv.net, aaron.lu@intel.com, linux-kernel@vger.kernel.org
References: <20130319023440.GA12425@aaronlu.sh.intel.com> <74A44E99E3274B4CB570415926B37D4414B14E@MUCSE501.eu.infineon.com> <9f68a46fb9ec6012668db36b7f7eff03@gentoo.se>
In-Reply-To: <9f68a46fb9ec6012668db36b7f7eff03@gentoo.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304012312.10083.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> > Also the flags etc would perhaps be handy, they can be retrieved via
> > sysfs - on you machine it _should_ be
> > # cat /sys/devices/pnp0/00:0a/*
> > and also post the output.
> 
> root@zepto:/home/peter# ls /sys/devices/pnp0/00\:0a/

Okay it seems it's not 00:0a ;/

Can you check the node in dmesg again?
You can try to find it also by
find /sys -name '*duration*' 


Thanks,
Peter


