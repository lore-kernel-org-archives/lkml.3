Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab3AOOrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 09:47:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:53542 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab3AOOrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 09:47:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: kishon <kishon@ti.com>
Subject: Re: [RFC PATCH 1/7] drivers: usb: phy: add a new driver for usb part of control module
Date: Tue, 15 Jan 2013 14:46:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: grant.likely@secretlab.ca, b-cousson@ti.com, rob.herring@calxeda.com,
        rob@landley.net, linux@arm.linux.org.uk, balbi@ti.com,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
References: <1358239378-10030-1-git-send-email-kishon@ti.com> <201301151336.47546.arnd@arndb.de> <50F56697.9060803@ti.com>
In-Reply-To: <50F56697.9060803@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301151446.53206.arnd@arndb.de>
X-Provags-ID: V02:K0:8oniSx0Ki6dqqAYm51eqLOhlEIt2uxV8oKKKBQNpy6z
 oEXNeK8od08xdpMbOsRT5o/kQ9shRka2sED76uHFNBxeHo+Wdu
 n/pyOKl+URM7IsmA0a3MtvjeFO4Bg//Is4GSZHOAoWzlq8hPX1
 OazSZEcEQ5Yv0pPjGWdU16YExH7alESQ3jkbTv88axEPQxgpI+
 3XcxcXJM1weNfUAmAMu5pu+WecfkvSkFw6WEJ3Y0rLglMSr5Gb
 ewEaSHZzHNNdJPBpQ0FsTTLhjbtwOiT+KbjionP799GPw5V/D0
 gn8lVMR0DBa+Y2D6jauc8CNTxH6q8hhClngsl395WnY+Tc2kW/
 94j607zoL4w0GVxCo+So=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2013, kishon wrote:
> Good point :-). Currently, none of the OMAP platforms have multiple 
> control modules and it doesn't seem to be in the future (AFAIK). While 
> it might be simpler to support multiple control devices with phandle, it 
> might face the same complications as faced by the USB PHY framework for 
> non-dt boot.
> 

Maybe you can put the phandle into the binding then but don't use it
until hardware actually requires it. If anything needs it, then we
can always change the code later, but it's harder to change the
binding.

	Arnd
