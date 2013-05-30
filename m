Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967661Ab3E3GpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 02:45:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41698 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967601Ab3E3GpF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 02:45:05 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Peter Korsgaard <jacmet@sunsite.dk>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>
CC: "poeschel@lemonage.de" <poeschel@lemonage.de>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] dts: am33xx: Correct properties on gpmc node
Thread-Topic: [PATCH] dts: am33xx: Correct properties on gpmc node
Thread-Index: AQHOW35Jhz7prP+DnUa2m40h+onjAZkaWt/xgALu5IA=
Date: Thu, 30 May 2013 06:44:02 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73E9C8B98@DBDE04.ent.ti.com>
References: <1369729497-11897-1-git-send-email-larsi@wh2.tu-dresden.de>
 <87mwrfbfgv.fsf@dell.be.48ers.dk>
In-Reply-To: <87mwrfbfgv.fsf@dell.be.48ers.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>>> "Lars" == Lars Poeschel <larsi@wh2.tu-dresden.de> writes:
> 
>  Lars> From: Lars Poeschel <poeschel@lemonage.de>
>  Lars> The gpmc driver is actually looking for "gpmc,num-cs" and
>  Lars> "gpmc,num-waitpins" properties in DT. The binding doc also states
>  Lars> this.
>  Lars> Correct the properties in the dts to provide the right values for the
>  Lars> gpmc driver.
> 
>  Lars> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> 
> Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
> 
Acked-by: Pekon Gupta <pekon@ti.com>

My another patch [V3, 2/3] on same can be dropped, in lieu of this one..
http://www.spinics.net/lists/linux-omap/msg91167.html


with regards, pekon
