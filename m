Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab3DBOeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:34:12 -0400
Received: from smtp3.nethome.no ([92.62.33.13]:36349 "EHLO smtp.nethome.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761244Ab3DBOeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:34:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Tue, 02 Apr 2013 16:34:05 +0200
From: peterasplund@gentoo.se
To: =?UTF-8?Q?Peter_H=C3=BCwe?= <PeterHuewe@gmx.de>
Cc: Kent Yoder <shpedoikal@gmail.com>, <tpmdd-devel@lists.sourceforge.net>,
        <Peter.Huewe@infineon.com>, <mail@srajiv.net>, <aaron.lu@intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [tpmdd-devel] =?UTF-8?Q?tpm=5Ftis=20driver=20failed=20to=20su?=
 =?UTF-8?Q?spend=2C=20error=20-=36=32?=
In-Reply-To: <201304012312.10083.PeterHuewe@gmx.de>
References: <20130319023440.GA12425@aaronlu.sh.intel.com>
 <74A44E99E3274B4CB570415926B37D4414B14E@MUCSE501.eu.infineon.com>
 <9f68a46fb9ec6012668db36b7f7eff03@gentoo.se>
 <201304012312.10083.PeterHuewe@gmx.de>
Message-ID: <e7604c3898e98954980165023f694d43@gentoo.se>
User-Agent: Roundcube Webmail/0.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-04-01 23:12 skrev Peter Hüwe:

     Hi Peter,

             Also the flags etc would perhaps be handy, they can be 
retrieved

         via

             sysfs - on you machine it _should_ be # cat 
/sys/devices/pnp0/00:0a/* and also post the output.

         root@zepto:/home/peter# ls /sys/devices/pnp0/00\:0a/

     Okay it seems it's not 00:0a ;/ Can you check the node in dmesg 
again? You can try to find it also by find /sys -name '*duration*'


root@zepto:/home/peter# find /sys -name '*duration*'
/sys/devices/pnp0/00:08/durations
and lots of usb devices...

root@zepto:/home/peter# cat /sys/devices/pnp0/00\:08/
active            durations         misc/             power/            
subsystem/
cancel            enabled           options           ppi/              
temp_deactivated
caps              firmware_node/    owned             pubek             
timeouts
driver/           id                pcrs              resources         
uevent

root@zepto:/home/peter# cat /sys/devices/pnp0/00\:08/*
1000000 4000000 152000000 [adjusted]
IFX0102
PNP0c31
state = active
mem 0xfed40000-0xfed44fff
io 0x4e-0x4f
io 0x1670-0x167f
irq 11
752000 2000000 752000 752000 [adjusted]
DRIVER=tpm_tis

I don't know if you want me to cat a specific file.. Perhaps the above 
is enough?

/Peter A

     Thanks, Peter
