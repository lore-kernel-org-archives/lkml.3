Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab3FGMhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 08:37:35 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:41664 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab3FGMhd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:37:33 -0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] ethernet/arc/arc_emac - Add new driver
Thread-Topic: [PATCH] ethernet/arc/arc_emac - Add new driver
Thread-Index: AQHOYR4xqQjJvxs/aUWp+iwP7UI3hw==
Date: Fri, 7 Jun 2013 12:37:24 +0000
Message-ID: <4881796E12491D4BB15146FE0209CE643F5C8E99@DE02WEMBXB.internal.synopsys.com>
References: <1370348510-23754-1-git-send-email-abrodkin@synopsys.com>
 <1505761.5DsauZd6eq@wuerfel>
 <4881796E12491D4BB15146FE0209CE643F5C77EC@DE02WEMBXB.internal.synopsys.com>
 <2468036.im0srnzmHT@wuerfel>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.121.8.30]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 04:13 PM, Arnd Bergmann wrote:
>>> I wonder if it would be better to name the directory "synopsys" or
>>> "designware" rather than "arc" now. Is there a chance that the same
>>> controller is used on non-arc CPUs?
>>
>> The thing is - "arc_emac" is a custom ARC's (that was implemented before
>> acquisition of ARC by Synopsys) IP (it's not an IC - just a part of CPU)
>> Ethernet controller that only exists in some legacy FPGA boards we
>> (ex-ARC and our customers) still use a lot in development process.
>>
>> Synopsys itself doesn't actively sell this device so there's no point in
>> putting ARC EMAC into Synopsys folder.
>>
>> And indeed we don't expect this device to be used with non-ARC CPU's.

I'm wondering if my clarification above makes sense and I may leave this 
driver in "ethernet/arc" or you still prefer it to be under 
"ethernet/synopsys"?

-Alexey
