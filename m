Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab3GPMAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:00:50 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:40255 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab3GPMAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:00:48 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Paul Zimmerman <paul.zimmerman@synopsys.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: DWC2 and/or S3C-HSOTG for STA2X11 board
Date: Tue, 16 Jul 2013 14:01:33 +0200
Message-ID: <38175373.Cq6zxae9tO@harkonnen>
User-Agent: KMail/4.10.4 (Linux/3.9.9-201.fc18.x86_64; KDE/4.10.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have an x86 board made by STMicroelectronics (STA2X11) with the Synopsis 
USB-OTG DesignWare 2 on it and connected through the PCI-e bus.


I know that there are two drivers for the same controller:

   (host)   drivers/staging/dwc2/*
   (device) drivers/usb/gadget/s3c-hsotg.{c|h}


So, at the moment I cannot have a board with both host/device working at the 
same time. I have to choose to use the block as device or host, right?

I know that the plan is to merge the s3c-hsotg in the dwc2 driver 
(https://lwn.net/Articles/540283/). Are still accepted patch to s3c-hsotg? Or 
it is work in progress right now (soon), so it is better to wait after the 
merge?

In order to use the s3c-hsotg I must implement a PCI wrapper that uses this 
driver. It will be accepted in the kernel even if it will be removed sooner or 
later because of the driver merge?

Thank you :)

-- 
Federico Vaga
