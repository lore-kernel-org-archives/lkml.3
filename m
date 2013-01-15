Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab3AONl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:41:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57329 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab3AONlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:41:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [RFC PATCH 0/7] usb: musb: add driver for control module
Date: Tue, 15 Jan 2013 13:41:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: grant.likely@secretlab.ca, b-cousson@ti.com, rob.herring@calxeda.com,
        rob@landley.net, linux@arm.linux.org.uk, balbi@ti.com,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
References: <1358239378-10030-1-git-send-email-kishon@ti.com>
In-Reply-To: <1358239378-10030-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301151341.08297.arnd@arndb.de>
X-Provags-ID: V02:K0:pE06H6V5+wsWkG4dxF/5tIrM4Rm2ncwfJ+x5zMNo47s
 9eAMiuIQexsbKACeBtbGRgfo0ZNBQDXNKr8JBHeDsOQv1MgcXu
 47TjdqzcbdrPt9Rg070PSvzFr0B2m/bZN9kLGFr41eG8cH9SJF
 TsDXkye6LEU2ZsuaDxyrAjlBCcI7ePBNeGUyF94FiRmUD0yan7
 Kolku5y1/qWYZoiE6hk9EsfNd9C1iQxCG9Lz8CBUIrygI7DvO4
 XP10AuIbNUkZtxwV75iujUM4xv0qPlsl9voJPCz66P+PhvYF4D
 e6K2p+CLI/wMzpjFJVWkTyLw9rBy3tbZIk9/ZOB1o9vkedp9Kn
 6zx9YNEboX39GcnyxFCg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2013, Kishon Vijay Abraham I wrote:
> Added a new driver for the usb part of control module. This has an API
> to power on the USB2 phy and an API to write to the mailbox depending on
> whether MUSB has to act in host mode or in device mode.
> 
> Writing to control module registers for doing the above task which was
> previously done in omap glue and in omap-usb2 phy is removed.
> 
> Also added the dt data to get MUSB working in OMAP platforms.
> This series has patches for both drivers and ARCH folders, so If it has to
> be split I'll do it.
> 

The series looks good to me, I just had a minor comment on one patch.

One a somewhat related topic, I wonder whether there are any plans
on your side to change this driver to support multiple bus glues
to be built for one kernel image. With a multiplatform kernel, we
may need all of TUSB6010/OMAP2PLUS/DSPS/UX500 for instance.

	Arnd
