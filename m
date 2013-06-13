Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552Ab3FMKDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 06:03:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57210 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758374Ab3FMKDB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 06:03:01 -0400
From: "Mohammed, Afzal" <afzal@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Benoit Cousson" <benoit.cousson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: RE: [PATCH v2 02/14] ARM: OMAP2+: AM43x: Kconfig
Thread-Topic: [PATCH v2 02/14] ARM: OMAP2+: AM43x: Kconfig
Thread-Index: AQHOWuhABF2KqV8mJ0y1adAsGP8LuZkx4/kAgAFoeoD//6+7AIAAhlWA
Date: Thu, 13 Jun 2013 10:02:18 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EB1E196@DBDE04.ent.ti.com>
References: <cover.1369658705.git.afzal@ti.com>
 <7642e0c701680ea94a8cc84059ff19e500813bf1.1369658705.git.afzal@ti.com>
 <20130612171200.GL8164@atomide.com>
 <C8443D0743D26F4388EA172BF4E2A7A93EB1DEB2@DBDE04.ent.ti.com>
 <20130613095454.GY8164@atomide.com>
In-Reply-To: <20130613095454.GY8164@atomide.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Thu, Jun 13, 2013 at 15:24:54, Tony Lindgren wrote:
> * Mohammed, Afzal <afzal@ti.com> [130613 00:04]:

> > Patch 10 "ARM: OMAP2+: AM43x: basic dt support" is missing in
> > omap-for-v3.11/soc branch and omap soc pull request, can you
> > please help patch 10 also to go upstream.
> 
> Hmm if that's .dts changes, Benoit needs to queue that.

It is not dts change.

Patch 10 patches board-generic.c for DT boot (Benoit has already
picked up dts, that is patch 14).

Regards
Afzal

