Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab3FMG67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 02:58:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35767 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478Ab3FMG6y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 02:58:54 -0400
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
Thread-Index: AQHOWuhABF2KqV8mJ0y1adAsGP8LuZkx4/kAgAFoeoA=
Date: Thu, 13 Jun 2013 06:58:10 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EB1DEB2@DBDE04.ent.ti.com>
References: <cover.1369658705.git.afzal@ti.com>
 <7642e0c701680ea94a8cc84059ff19e500813bf1.1369658705.git.afzal@ti.com>
 <20130612171200.GL8164@atomide.com>
In-Reply-To: <20130612171200.GL8164@atomide.com>
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

On Wed, Jun 12, 2013 at 22:42:00, Tony Lindgren wrote:

> I've updated this patch to remove the "default y" and
> "depends on ARCH_OMAP2PLUS" entries for the usual reasons
> and applied the first ten patches into omap-for-v3.11/soc.

Thanks.

Patch 10 "ARM: OMAP2+: AM43x: basic dt support" is missing in
omap-for-v3.11/soc branch and omap soc pull request, can you
please help patch 10 also to go upstream.

Regards
Afzal

