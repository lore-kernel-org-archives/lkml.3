Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab3BSLBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 06:01:18 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56349 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932261Ab3BSLBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 06:01:16 -0500
Message-ID: <51235BB7.2050600@ti.com>
Date: Tue, 19 Feb 2013 16:32:15 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Mohammed, Afzal" <afzal@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, "Nori, Sekhar" <nsekhar@ti.com>,
        "Syed Mohammed, Khasim" <khasim@ti.com>
Subject: Re: [PATCH, RFC 4/8] ARM: am33xx: ll debug config help
References: <cover.1361186097.git.afzal@ti.com> <bfe941adb98a5000c2817f9fd6160070e59e53c9.1361186097.git.afzal@ti.com> <51235337.60209@ti.com> <C8443D0743D26F4388EA172BF4E2A7A93EAA867A@DBDE01.ent.ti.com>
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93EAA867A@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2013 04:00 PM, Mohammed, Afzal wrote:
> Hi Santosh,
>
> On Tue, Feb 19, 2013 at 15:55:59, Shilimkar, Santosh wrote:
>
>> With DT, IIRC DEBUGLL is broken. So did you hack debug-macro.S
>> to get the earlyprintk working ?
>
> No, on linux-next, ll debug works properly.
>
Indeed. Tony fixed that now. Some how I missed
this patch on the list.

Regards,
Santosh
