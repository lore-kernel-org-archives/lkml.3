Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab3BLG4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 01:56:33 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40186 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab3BLG4b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 01:56:31 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Paul Walmsley <paul@pwsan.com>
CC: "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
Subject: RE: [PATCH 4/7] ARM: AM33XX: clk: Add clock node for EHRPWM TBCLK
Thread-Topic: [PATCH 4/7] ARM: AM33XX: clk: Add clock node for EHRPWM TBCLK
Thread-Index: AQHN6Oyyn3+GFX+8KkiOyfpfoYOW65hv7c6AgAYbjEA=
Date: Tue, 12 Feb 2013 06:55:18 +0000
Deferred-Delivery: Tue, 12 Feb 2013 06:55:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA73534@DBDE01.ent.ti.com>
References: <1357133094-30806-1-git-send-email-avinashphilip@ti.com>
 <1357133094-30806-5-git-send-email-avinashphilip@ti.com>
 <alpine.DEB.2.00.1302081505350.28008@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1302081505350.28008@utopia.booyaka.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 20:36:53, Paul Walmsley wrote:
> Hi,
> 
> On Wed, 2 Jan 2013, Philip Avinash wrote:
> 
> > EHRPWM module requires explicit clock gating of TBCLK from control
> > module. Hence add TBCLK clock node in clock tree for EHRPWM modules.
> > 
> > Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> 
> This patch adds some sparse[1] warnings:
> 
> > arch/arm/mach-omap2/cclock33xx_data.c:844:1: warning: Using plain 
> integer as NULL pointer
> > arch/arm/mach-omap2/cclock33xx_data.c:850:1: warning: Using plain 
> integer as NULL pointer
> > arch/arm/mach-omap2/cclock33xx_data.c:856:1: warning: Using plain 
> integer as NULL pointer
> 
> Could you fix these, please?

Sorry for late response. I will send an updated version with fix for
sparse warnings.

Thanks
Avinash

> 
> 
> - Paul
> 
> 1. Sparse: https://sparse.wiki.kernel.org/index.php/Main_Page
> 
> 

