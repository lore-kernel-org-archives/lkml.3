Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab3KNSZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 13:25:34 -0500
Received: from mout.gmx.net ([212.227.17.21]:53357 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073Ab3KNSZ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 13:25:27 -0500
Date: Thu, 14 Nov 2013 19:25:23 +0100
From: Andreas Werner <wernerandy@gmx.de>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Black screen with GMA500 driver on Atom E680 (invalid VBT
 signature)
Message-ID: <20131114182523.GA2133@thinkpad.fritz.box>
References: <20131113183418.GA1593@thinkpad.fritz.box>
 <20131114135209.0a8a15ff@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131114135209.0a8a15ff@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:vbqkSU5FcvSOa1uozT1KYNO3fZLmdFCK1duYU5dCR3BGX0qzqei
 WdUGgz+U3rzAJC1RpwMIokUnI7q9yzLq4XGUeE6EGb9buHG9B6YQZTrm6PmSF80GjFCmeWm
 KgMB8PDo1wBpAD9IoKmUOoRpPVcO7ZJYOceBQx4FUT38EiNIAU6V2tPFShpU6/hGfjlbDNa
 IQSa3JPWrmthN0y5R8T4Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 01:52:09PM +0000, One Thousand Gnomes wrote:
> > My question now is, is it a bug in the driver or in the VGA Bios?
> > 
> > I´ve checked the VGA bios and did a hex dump but there is really no "$VBT" string.
> > On an Atom Gen1 CPU with intel GMA500 Graphic there is the string in the VGA BIOS.
> > But if i create the VGA BIOS for intel Atom E680 which has a GMA600 Graphic
> > there is no string.
> > 
> > Does anybody of you running the GMA500 driver with and Atom E680 without having this
> > problem? Or does anybody know how to get this string into the VGA BIOS?
> 
> E680 I believe will try and use the other style of parsing. I never got
> my hands on one to confirm that but in general E6xx seems to use
> Moorestown style tables instead and you'll only get support for some
> outputs.
> 
Hi,
but if you checkout the PCI table in the driver, there is the device
and vendor ID mentioned, that means for me that the driver supports
the Graphic core in E680.
And after loading the driver, it will parse for $VBT.
I just find a comment in the PCI table with "E620" but
the device and vendor id is the same for E680.

What do you mean with "Moorestown style" ?

Regards
Andy
