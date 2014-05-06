Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbaEFMK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:10:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50773 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753674AbaEFMK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:10:27 -0400
Date: Tue, 6 May 2014 14:10:23 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Mathias Nyman <mathias.nyman@intel.com>, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Lior Amsalem <alior@marvell.com>, Rob Herring <robh+dt@kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v3 06/20] usb: host: xhci-plat: Add support for the
 Armada 38x
Message-ID: <20140506141023.715b932d@skate>
In-Reply-To: <61061197.hLhKsFqJLF@wuerfel>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
	<1399335255-589-7-git-send-email-gregory.clement@free-electrons.com>
	<1584794.IM1uiSkBdk@amdc1032>
	<61061197.hLhKsFqJLF@wuerfel>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Arnd Bergmann,

On Tue, 06 May 2014 13:57:44 +0200, Arnd Bergmann wrote:

> > Please limit this driver to mvebu arch and compile testing, i.e.
> > 
> >         depends on ARCH_MVEBU || COMPILE_TEST
> 
> I think it actually needs a dependency on MVEBU_MBUS.

That's not what we do for any of the other drivers that use the
MVEBU_MBUS functions.

> You probably need something like
> 
> 	depends on MVEBU_MBUS=y || (MVEBU_MBUS=m && USB_XHCI=m)

MVEBU_MBUS is a bool, so there is no way is can be =m.

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
