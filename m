Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab3JNS0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:26:55 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6985 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab3JNS0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:26:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 14 Oct 2013 11:26:53 -0700
Message-ID: <525C376A.3000009@nvidia.com>
Date: Mon, 14 Oct 2013 14:26:50 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Darbha Sriharsha <dsriharsha@nvidia.com>,
        Manish Badarkha <badarkhe.manish@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [Patch V5] drivers: power: Add support for bq24735 charger
References: <1381526143-20800-1-git-send-email-rklein@nvidia.com> <525C361C.1020703@wwwdotorg.org>
In-Reply-To: <525C361C.1020703@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 2:21 PM, Stephen Warren wrote:
> On 10/11/2013 03:15 PM, Rhyland Klein wrote:
>> From: Darbha Sriharsha <dsriharsha@nvidia.com>
>>
>> Adds support for the bq24735 charger chipset. The bq24735 is a
>> high-efficiency, synchronous battery charger.
>>
>> It allows control of the charging current, input current, and the charger
>> voltage DAC's through SMBus.
> 
> Please CC the DT bindings maintainers on patches that add DT bindings.

Oops, sorry, will do in the future.

> 
>> diff --git a/Documentation/devicetree/bindings/power_supply/ti,bq24735.txt b/Documentation/devicetree/bindings/power_supply/ti,bq24735.txt
> 
>> +Optional properties :
> 
>> + - ti,ac-detect-gpios : This GPIO is optionally used to read the AC adapter
>> +   presence.
> 
> Is that actually a property of the BQ24735 chip itself (i.e. is it an
> output signal from the chip), or part of the board/system?

The gpio itself is actually what the IRQ line is tied to from the
bq24735 -> tegra (in this case). In other words this is a Host GPIO that
is configured as an input and connected to the bq24735.

-rhyland

> 
> Aside from that, the binding looks reasonable to me (although I'm no
> longer a DT bindings maintainer).
> 


-- 
nvpublic
