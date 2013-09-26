Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab3IZGQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:16:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56180 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab3IZGQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:16:12 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Brian Norris <computersforpeace@gmail.com>,
        "olof@lixom.net" <olof@lixom.net>
CC: "benoit.cousson@linaro.org" <benoit.cousson@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "avinashphilipk@gmail.com" <avinashphilipk@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: RE: [PATCH v6 1/4] ARM: OMAP2+: cleaned-up DT support of various
 ECC schemes
Thread-Topic: [PATCH v6 1/4] ARM: OMAP2+: cleaned-up DT support of various
 ECC schemes
Thread-Index: AQHOr65J/YAMcn2UDkuZTZSW+mOACZnVQHoggADFRoCAAEWcgIAAihnw//+aR4CAAS7NcA==
Date: Thu, 26 Sep 2013 06:15:17 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EA16B22@DBDE04.ent.ti.com>
References: <1378986619-26765-1-git-send-email-pekon@ti.com>
 <1378986619-26765-2-git-send-email-pekon@ti.com>
 <20980858CB6D3A4BAE95CA194937D5E73EA15ED7@DBDE04.ent.ti.com>
 <20130925134619.GG10746@radagast>
 <20130925175527.GA23337@ld-irv-0074.broadcom.com>
 <20980858CB6D3A4BAE95CA194937D5E73EA16884@DBDE04.ent.ti.com>
 <20130925200539.GH23337@ld-irv-0074.broadcom.com>
In-Reply-To: <20130925200539.GH23337@ld-irv-0074.broadcom.com>
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


> 
> Anyway, at this point I think your patch series should be nearly
> complete. I made a few comments on your patches, and I'd imagine you
> only should need one more revision (v7) before I can accept it to the
> l2-mtd.git tree.
> 
Yes surely I will send next version (v7), but it might take few days.
As some more feedbacks on [PATCH 1] are pending for final conclusion
and this needs to be properly re-tested.

And thanks much to you and Olof for the feedbacks.
I agree some of Olof's feedbacks on DT bindings gave me new view to
look at things, And further simplified the NAND driver code.

with regards, pekon
