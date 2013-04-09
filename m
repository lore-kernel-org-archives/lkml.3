Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936396Ab3DIU7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:59:30 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:38905 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936020Ab3DIU73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:59:29 -0400
Date: Tue, 9 Apr 2013 20:59:27 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
cc: rnayak@ti.com, b-cousson@ti.com, tony@atomide.com, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Keerthy <j-keerthy@ti.com>
Subject: Re: [PATCH] ARM: OMAP4: HWMOD: make 'ocp2scp_usb_phy_phy_48m" as
 the main clock
In-Reply-To: <1365496101-7829-1-git-send-email-kishon@ti.com>
Message-ID: <alpine.DEB.2.00.1304092058450.26840@utopia.booyaka.com>
References: <1365496101-7829-1-git-send-email-kishon@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="843723315-1289092044-1365541167=:26840"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--843723315-1289092044-1365541167=:26840
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi

On Tue, 9 Apr 2013, Kishon Vijay Abraham I wrote:

> commit 92702d (ARM: OMAP4: PM: fix PM regression introduced by recent
> clock cleanup) makes the 'ocp2scp_usb_phy_phy_48m' as optional
> functional clock causing regression in MUSB. But this 48MHz clock is a
> mandatory clock for usb phy attached to ocp2scp and hence made as the mai=
n
> clock for ocp2scp.
>=20
> Cc: Keerthy <j-keerthy@ti.com>
> Cc: Beno=C3=AEt Cousson <b-cousson@ti.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

This patch is missing the "big comment" that I requested in the hwmod=20
data:

http://marc.info/?l=3Dlinux-omap&m=3D136544098331552&w=3D2

Once that's added, it should be good to go.


- Paul
--843723315-1289092044-1365541167=:26840--
