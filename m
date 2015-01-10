Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbbAJONo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 09:13:44 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:64665 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbbAJONm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 09:13:42 -0500
MIME-Version: 1.0
In-Reply-To: <1417642402-20538-1-git-send-email-marek@goldelico.com>
References: <1417642402-20538-1-git-send-email-marek@goldelico.com>
Date: Sat, 10 Jan 2015 15:13:40 +0100
Message-ID: <CAAfyv35nBYmcRBWWCsCHnSqJ1qJ59QShDL6fvYjsYMaNUkcRYA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] omapdss: Add video output support for gta04
From: Belisko Marek <marek.belisko@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-fbdev@vger.kernel.org, Marek Belisko <marek@goldelico.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomi can you please pick up this series for 3.20 release? Thanks

On Wed, Dec 3, 2014 at 10:33 PM, Marek Belisko <marek@goldelico.com> wrote:
> changes from v3:
> - use GPL v2 instead GPL
> - fix wrong gpios property name in doc and DT
> - set gpio to NULL if invalid
> - drop unnecessary header
>
> changes from v2:
> - rename amplifier-opa362.c to encoder-opa362
> - drop inversion handlign from driver
> - add ti,invert-polarity to venc node
>
> I also drop devconf1 handling patches because discussion how to
> properly implement is not yet finished and this part is independent
> from video driver.
>
> changes from v1:
> - fix opa362 compilation error
> - fix opa362 DT documentation
> - move devconf1 definition to omap3.dtsi
> Marek Belisko (3):
>   video: omapdss: Add opa362 driver
>   Documentation: DT: Add documentation for ti,opa362 bindings
>   arm: dts: omap3-gta04: Add handling for tv output
>
>  .../devicetree/bindings/video/ti,opa362.txt        |  38 +++
>  arch/arm/boot/dts/omap3-gta04.dtsi                 |  49 ++++
>  drivers/video/fbdev/omap2/displays-new/Kconfig     |   6 +
>  drivers/video/fbdev/omap2/displays-new/Makefile    |   1 +
>  .../fbdev/omap2/displays-new/encoder-opa362.c      | 285 +++++++++++++++++++++
>  5 files changed, 379 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/video/ti,opa362.txt
>  create mode 100644 drivers/video/fbdev/omap2/displays-new/encoder-opa362.c
>
> --
> 1.9.1
>

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
