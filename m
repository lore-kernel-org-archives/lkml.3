Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbaBKUKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:10:48 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35864 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755AbaBKUKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:10:44 -0500
Message-ID: <52FA839F.5090304@ti.com>
Date: Tue, 11 Feb 2014 14:10:07 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: omap3-n9 family: mark proper OMAP version
References: <1392132541-25340-1-git-send-email-nm@ti.com> <20140211185136.GG573@drone.musicnaut.iki.fi>
In-Reply-To: <20140211185136.GG573@drone.musicnaut.iki.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aaro,
On 02/11/2014 12:51 PM, Aaro Koskinen wrote:
> Hi,
> 
> On Tue, Feb 11, 2014 at 09:29:01AM -0600, Nishanth Menon wrote:
>> Nokia N900 uses OMAP3430 and N9/N950 uses OMAP3630. Mark SoC compatibilty
>> as per Documentation/devicetree/bindings/arm/omap/omap.txt else
>> N9/N950 will be probed as a OMAP3430 type device, since default ti,omap3
>> maps to OMAP3430 compatibility.
> 
> I already sent & tested patches for this:
> 
> http://marc.info/?l=linux-omap&m=139194800711362&w=2
> http://marc.info/?l=linux-omap&m=139194800011360&w=2
> 
> The N9/N950 is mandatory for 3.14, as the boot hangs without it.

Thanks. Apologies on missing these, I caught these based on a git grep
on an unrelated thing.. I will ack your patches - they are obvious
regressions.


-- 
Regards,
Nishanth Menon
