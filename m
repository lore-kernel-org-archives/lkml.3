Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154AbaEXGrJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 02:47:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58590 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750736AbaEXGrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 02:47:07 -0400
Date: Sat, 24 May 2014 08:46:58 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/5] phy: add support for USB cluster on the Armada 375
 SoC
Message-ID: <20140524084658.30e307fb@free-electrons.com>
In-Reply-To: <537FC2BE.1040501@free-electrons.com>
References: <1400257376-13251-1-git-send-email-gregory.clement@free-electrons.com>
	<537F12F5.2030102@ti.com>
	<537FC2BE.1040501@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory, Kishon,

On Fri, 23 May 2014 23:50:54 +0200, Gregory CLEMENT wrote:

> >> +MODULE_DESCRIPTION("Armada 375 USB cluster driver");
> >> +MODULE_AUTHOR("Gregory CLEMENT <gregory.clement@free-electrons.com>");
> >> +MODULE_LICENSE("GPL");
> > 
> > GPL v2?
> 
> See the header, I chose "GNU General Public License version 2 or later."
> so "GPL" match it.

And also, the vast majority of kernel drivers use
MODULE_LICENSE("GPL") :

$ git grep 'MODULE_LICENSE("GPL")' | wc -l
5615
$ git grep 'MODULE_LICENSE("GPLv2")' | wc -l
5
$ git grep 'MODULE_LICENSE("GPL v2")' | wc -l
932

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
