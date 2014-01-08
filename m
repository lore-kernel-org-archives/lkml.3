Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbaAHLgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:36:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59892 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaAHLf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:35:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/5] mfd: omap-usb-host: Update DT clock binding information
Date: Wed, 8 Jan 2014 12:35:40 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Roger Quadros <rogerq@ti.com>, Sebastian Reichel <sre@debian.org>,
        devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        tony@atomide.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com,
        "Kristo, Tero" <t-kristo@ti.com>, bcousson@baylibre.com,
        linux-omap@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
References: <1389161742-10533-1-git-send-email-rogerq@ti.com> <3761842.HRY1CDBF4z@wuerfel> <52CD324D.3020701@ti.com>
In-Reply-To: <52CD324D.3020701@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401081235.40927.arnd@arndb.de>
X-Provags-ID: V02:K0:HcDeunmEVIeboUV09K0SUGl2QLJIE3h3DFyIw+QRloV
 l8mjVuQZv6MeE88SXqeAf8uoldp0H4i8NGuOMGhbnf4LYgoWEO
 WSLvZgyJzUD6bpC8t3WQ7WHilB6Zpp9P6QdXXlsiLwAbbY4WR1
 m3X/1QU9fp5dyNnLBisjpBRrpV6WggMlc2fnhwHZuysnMh/0Df
 X0hqA/UsbQGy/WK7TEdeFxnGygfiAmJV69g4/m1coebe1x+Kmg
 ydCXQwyBhvv75v2YUF6LVJoOS8apkNe1+DIVxeWTFN+56qlg6z
 M4nVSxr50HV/W9Mrjn9KLHpAmOxCAB2DRt3aixdjBKwQEwkiBk
 pkgYfu/I1m1pBMvvs+UQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 January 2014, Roger Quadros wrote:
> OK. I'll update the binding information to reflect all the clocks.
> 
> But what about clk_get() vs of_clk_get_by_name() ?

I think the convention these days is to just use clk_get(), which calls
of_clk_get_by_name() internally. Not sure if that's what you are asking.

	Arnd
