Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab3GTHiQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 03:38:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36623 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab3GTHiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 03:38:14 -0400
Message-ID: <1374305890.8385.53.camel@cumari.coelho.fi>
Subject: Re: Regression 3.11-rc1: omap4panda: no usb and consequently no
 ethernet
From: Luciano Coelho <coelho@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Arend van Spriel <arend@broadcom.com>, <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Date: Sat, 20 Jul 2013 10:38:10 +0300
In-Reply-To: <20130718085951.GT7656@atomide.com>
References: <51E7AA24.6080600@broadcom.com>
	 <20130718085951.GT7656@atomide.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-18 at 01:59 -0700, Tony Lindgren wrote:
> * Arend van Spriel <arend@broadcom.com> [130718 01:47]:
> Then for the SDIO with device tree, take a look at the following
> patches:
> 
> [PATCH 0/3] WLAN support for omap4 when booted with devicetree
> http://comments.gmane.org/gmane.linux.ports.arm.omap/97522#
> 
> The wl12xx .dts changes for pandaboard are still missing too.

Just for the record, I already have the DTS patches for wl12xx on Panda
(and a few other boards).

I held them back because I wanted the bindings to be properly defined
first.  I'll continue this work pretty soon, when I come back from my
summer vacations (in a week).

--
Cheers,
Luca.

