Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab3KNU60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:58:26 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58007 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab3KNU6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:58:19 -0500
Date: Thu, 14 Nov 2013 20:57:58 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andreas Werner <wernerandy@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Black screen with GMA500 driver on Atom E680 (invalid VBT
 signature)
Message-ID: <20131114205758.78c0788d@alan.etchedpixels.co.uk>
In-Reply-To: <20131114182523.GA2133@thinkpad.fritz.box>
References: <20131113183418.GA1593@thinkpad.fritz.box>
	<20131114135209.0a8a15ff@alan.etchedpixels.co.uk>
	<20131114182523.GA2133@thinkpad.fritz.box>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> but if you checkout the PCI table in the driver, there is the device
> and vendor ID mentioned, that means for me that the driver supports
> the Graphic core in E680.
> And after loading the driver, it will parse for $VBT.
> I just find a comment in the PCI table with "E620" but
> the device and vendor id is the same for E680.
> 
> What do you mean with "Moorestown style" ?

There are essentially two styles of configuration table used with PVR
graphics. One is basically the same as that used on 'real' Intel graphics
the other first introduced with one of the SoC devices is a firmware
table in a completely different format.

The netbook and PC oriented devices use the VBT, the tablet SoC
devices and embedded ones seem to vary and have a VBT/GCT in different
form that is found via config 0xFC on the chipset - see mid_bios.c

Alan
