Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684Ab3EBQ1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 12:27:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61007 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927Ab3EBQ1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 12:27:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH, RFC 08/22] OMAPDSS: DPI needs DSI
Date: Thu, 2 May 2013 18:26:41 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <1367507786-505303-9-git-send-email-arnd@arndb.de> <5182896F.90807@ti.com>
In-Reply-To: <5182896F.90807@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305021826.41263.arnd@arndb.de>
X-Provags-ID: V02:K0:H6SbkVKWWTDcAGJIc4OUhYwnosaRbbrvuCJ+y+tvmGV
 +CXbkjN0COeB0VRoBrCHKuZ5EylBz23VZCbTFDyq/8E8tu+oww
 3Fl0EVP00t6fdERQTjNzK8OjV/v35/mKhUpoxgRx+9TjobmKJ3
 gI491Sm25QMkaOOMJmfQ61SuVqMPgZNFNX2E7zBbmSO1j/F/YQ
 +GotwYSGPgSbsbuHiGbR9lvD0TvwSz8ZtO78IXZboR6+IzLOlh
 i51hgMAyiDLe/db6Lvi9fUCrMuSFjedT0RKSqe+KhyjzFL6Sjf
 4ny/u4SfFFSQNKLHE/3cO3VU/e09pE8eUlGXK7+eh9k3C+F2ux
 8YpvhJ2yXx3GakV7dQLw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 May 2013, Tomi Valkeinen wrote:
> On 05/02/2013 06:16 PM, Arnd Bergmann wrote:
> > The dpi.c file cannot be build correctly when the dsi.c file is
> > disabled in Kconfig. This clarifies the dependency in Kconfig
> > to avoid build errors:
> > 
> > drivers/video/omap2/dss/dpi.c: In function 'dpi_calc_pll_cb':
> > drivers/video/omap2/dss/dpi.c:181:2: error: implicit declaration of function 'dsi_hsdiv_calc' [-Werror=implicit-function-declaration]
> > drivers/video/omap2/dss/dpi.c: In function 'dpi_dsi_clk_calc':
> > drivers/video/omap2/dss/dpi.c:201:2: error: implicit declaration of function 'dsi_get_pll_clkin' [-Werror=implicit-function-declaration]
> 
> I've sent a patch for this to DRM maintainer, hopefully merged soon.
> 

Ok, thanks!

	Arnd
