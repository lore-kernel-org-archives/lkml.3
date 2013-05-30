Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967821Ab3E3HkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:40:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60273 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967621Ab3E3HkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:40:02 -0400
Message-ID: <51A70225.50300@ti.com>
Date: Thu, 30 May 2013 09:39:17 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Gupta, Pekon" <pekon@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Philip, Avinash" <avinashphilip@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "zonque@gmail.com" <zonque@gmail.com>,
        "jacmet@sunsite.dk" <jacmet@sunsite.dk>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: Re: [v2, 3/3] ARM: dts: AM33XX: Add NAND flash device tree data to
 am335x-evm
References: <ebfab3e9123b3e50b9a9678c1480191addd86d59.1359007746.git.avinashphilip@ti.com> <517F5126.5000509@ti.com> <20130508235404.GX32546@atomide.com> <20980858CB6D3A4BAE95CA194937D5E73E9C320D@DBDE04.ent.ti.com> <20980858CB6D3A4BAE95CA194937D5E73E9C5629@DBDE04.ent.ti.com> <51A6FEA8.5030704@ti.com> <20980858CB6D3A4BAE95CA194937D5E73E9C8BCD@DBDE04.ent.ti.com>
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73E9C8BCD@DBDE04.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 09:31 AM, Gupta, Pekon wrote:
>> Sorry, I missed that series.
>>
>> I'm applying it right now.
>>
> No issues.. Please pick newer v4 versions of this series.
> Following are rebased, updated and tested on linux-3.10-rc3
> 
> [PATCH v4,0/3] http://www.spinics.net/lists/linux-omap/msg91165.html
> 
> [PATCH v4,1/3] http://www.spinics.net/lists/linux-omap/msg91166.html
> 
> [PATCH v4,2/3] (please skip this one)
> instead pick http://www.spinics.net/lists/linux-omap/msg91161.html
> 
> [PATCH v4,3/3] http://www.spinics.net/lists/linux-omap/msg91167.html

Could you please rebase on for_3.11/dts and repost the whole stuff. It
looks like Tony already pulled the GPMC node, and the two other ones
cannot apply anymore.

Thanks,
Benoit

