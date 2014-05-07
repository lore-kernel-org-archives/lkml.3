Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbaEGMux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:50:53 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58478 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751487AbaEGMuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:50:51 -0400
Date: Wed, 7 May 2014 14:50:48 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        devicetree@vger.kernel.org, Nadav Haklai <nadavh@marvell.com>,
        Rob Herring <robh+dt@kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 17/20] phy: Add support for USB cluster on the Armada
 375 SoC
Message-ID: <20140507145048.19bd1306@free-electrons.com>
In-Reply-To: <2511421.HV0z8e3QV0@amdc1032>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
	<1399335255-589-18-git-send-email-gregory.clement@free-electrons.com>
	<2511421.HV0z8e3QV0@amdc1032>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Bartlomiej Zolnierkiewicz,

On Tue, 06 May 2014 13:37:04 +0200, Bartlomiej Zolnierkiewicz wrote:

> > +config ARMADA375_USBCLUSTER_PHY
> > +	def_bool y
> > +	depends on OF
> 
> Please limit this driver to Armada 375 or compile testing, i.e. add additional
> 
> 	depends on (ARCH_MVEBU && MACH_ARMADA_375) || COMPILE_TEST

Right, will do.

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
