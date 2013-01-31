Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab3AaD7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 22:59:33 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44030 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab3AaD7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 22:59:30 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        Peter Korsgaard <jacmet@sunsite.dk>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: RE: [PATCH] mtd: devices: elm: Removes <xx> literals in elm DT node
Thread-Topic: [PATCH] mtd: devices: elm: Removes <xx> literals in elm DT node
Thread-Index: AQHN+f9qqkSkkioaZU6wr/+Q37A4LZhYJjmTgAqzFBA=
Date: Thu, 31 Jan 2013 03:58:04 +0000
Deferred-Delivery: Thu, 31 Jan 2013 03:58:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA6870C@DBDE01.ent.ti.com>
References: <9580c5839ea64e09ddd61610ce922d7cd1adc861.1359010256.git.avinashphilip@ti.com>
 <8738xr2dap.fsf@dell.be.48ers.dk>
In-Reply-To: <8738xr2dap.fsf@dell.be.48ers.dk>
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

Hi Artem,

On Thu, Jan 24, 2013 at 14:00:38, Peter Korsgaard wrote:
> >>>>> "Philip" == Philip Avinash <avinashphilip@ti.com> writes:
> 
>  Philip> As part of removing generalized dependency, replace <xx>
>  Philip> literal fields in DT compatible field with <52> for am335x
>  Philip> platforms.
> 
> Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

Can you please accept this patch for am3352 compatibility in ELM node.

Peter,
Thanks for ack.

Thanks
Avinash

> 
> -- 
> Bye, Peter Korsgaard
> 

