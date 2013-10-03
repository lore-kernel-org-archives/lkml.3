Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3JCXvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 19:51:08 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36497 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab3JCXvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 19:51:05 -0400
Message-ID: <1380844258.1708.6.camel@desktop.site>
Subject: Re: [opensuse-factory] huawei usb dongle e173 not working on
 tumbleweed
From: Ron Brickle <rb19495@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: mdharm-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-kernel@vger.kernel.org
Date: Fri, 04 Oct 2013 06:50:58 +0700
In-Reply-To: <524DA43B.3080700@lwfinger.net>
References: <1380765777.1723.5.camel@desktop.site>
		 <524CEADE.8040300@lwfinger.net> <1380784395.1672.7.camel@desktop.site>
	 <524DA43B.3080700@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-03 at 12:07 -0500, Larry Finger wrote:
> On 10/03/2013 02:13 AM, Ron Brickle wrote:
> > On Wed, 2013-10-02 at 22:56 -0500, Larry Finger wrote:
> >> On 10/02/2013 09:02 PM, Ron Brickle wrote:
> >>> Hi I have been trying to get my huawei usb dongle working on Tumbleweed
> >>> but to no avail so in desperation I am sending  this email. it works
> >>> fine on 12.3 opensuse  so hopefully you can fix this problem I tried to
> >>> get it working from help from the tumbleweed forum it is recognized in
> >>> lsusb but doesn show in network-manager
> >>> regards and thanks Ron Brickle
> >>
> >> Firmware?
> >>
> >> A device present in lsusb only means that it is connected to the USB system. For
> >> NM to have it, any firmware must be present, the wifi-enable switch for *ALL*
> >> devices must be on, the device must be recognized by some driver, and that
> >> driver must load and initialize correctly. From the information you provided, it
> >> is impossible to tell where it is failing.
> >>
> >> Larry
> >>
> >> Hi i just put this in terminal as normal user then as root
> >
> > rpm -ql usb_modeswitch-data|grep 1446
> > it returns no answer and it should be this I am told if so the driver
> > isnt installed for this usb modem TargetVendor=  0x12d1
> > TargetProductList="1001,1406,140b,140c,1412,141b,1433,1436,14ac,1506"
> >
> > MessageContent="55534243123456780000000000000011062000000100000000000000000000"
> > is this any help
> > regards ron
> > lsusb gives thisron@desktop:~> rpm -ql usb_modeswitch-data|grep 1446
> > ron@desktop:~> lsusb
> > Bus 001 Device 002: ID 8087:8008 Intel Corp.
> > Bus 002 Device 002: ID 8087:8000 Intel Corp.
> > Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> > Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> > Bus 001 Device 003: ID 046d:0809 Logitech, Inc. Webcam Pro 9000
> > Bus 002 Device 003: ID 174c:2074 ASMedia Technology Inc.
> > Bus 002 Device 004: ID 2109:2812
> > Bus 002 Device 007: ID 12d1:1446 Huawei Technologies Co., Ltd.
> > E1552/E1800/E173 (HSPA modem)
> > Bus 002 Device 005: ID 046d:c526 Logitech, Inc. Nano Receiver
> > Bus 002 Device 006: ID 046d:c52b Logitech, Inc. Unifying Receiver
> > and usb-devices gives this
> >   Bus=02 Lev=03 Prnt=04 Port=00 Cnt=01 Dev#=  7 Spd=480 MxCh= 0
> > D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> > P:  Vendor=12d1 ProdID=1446 Rev=00.00
> > S:  Manufacturer=HUAWEI Technology
> > S:  Product=HUAWEI Mobile
> > C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=500mA
> > I:  If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50
> > Driver=usb-storage
> > I:  If#= 1 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50
> > Driver=usb-storage
> >   thanks for your reply regards ron
> 
>  From the usb-devices output, the device obviously needs to be mode switched.
> 
> There may be a regression from the openSUSE 12.3 kernel (probably 3.7) to the 
> one used by Tumbleweed. The usb-storage drivers are maintinaed by Matthew Dharm 
> <mdharm-usb@one-eyed-alien.net>. I suggest you contact him with a Cc to 
> linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, and 
> linux-kernel@vger.kernel.org and and state your problem, that it worked in 
> kernel 3.7, but fails in the kernel 3.XX with the XX replaced by the version 
> returned by 'uname -r'.
> 
> Larry
> 
> 


