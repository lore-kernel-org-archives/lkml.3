Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab3LRLLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 06:11:54 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44007 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780Ab3LRLLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 06:11:51 -0500
Message-ID: <52B18265.5090404@ti.com>
Date: Wed, 18 Dec 2013 13:09:25 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <grygorii.strashko@ti.com>,
        <dwmw2@infradead.org>
Subject: Re: [PATCH v4 0/9] Reuse davinci-nand driver for Keystone arch
References: <1387285155-19182-1-git-send-email-ivan.khoronzhuk@ti.com> <20131218071457.GB5551@norris-Latitude-E6410>
In-Reply-To: <20131218071457.GB5551@norris-Latitude-E6410>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 09:14 AM, Brian Norris wrote:
> On Tue, Dec 17, 2013 at 02:59:06PM +0200, Ivan Khoronzhuk wrote:
>> This series contains fixes and updates of Davinci nand driver in
>> order to reuse it for Keystone platform.
>>
>> v3..v4:
>> - mtd: nand: davinci: fix driver registration
>> 	dropped __init/__exit/__exit_p as module_platform_driver() is used
>> - mtd: nand: davinci: adjust DT properties to MTD generic
>> 	used of_get_nand_bus_width() helper
>> - mtd: nand: davinci: don't request AEMIF address range
>> 	added comment at code change
>
> Pushed the series to l2-mtd.git. Thanks!
>
> Brian
>

Thanks

-- 
Regards,
Ivan Khoronzhuk
