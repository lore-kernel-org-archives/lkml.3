Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbaGHNBC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:01:02 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:65519 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbaGHNA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:00:59 -0400
Message-ID: <53BBEB84.50904@gmail.com>
Date: Tue, 08 Jul 2014 15:00:52 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: Kishon Vijay Abraham I <kishon@ti.com>,
        =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        tj@kernel.org
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 1/7] phy: add a driver for the Berlin SATA PHY
References: <1404728173-20263-1-git-send-email-antoine.tenart@free-electrons.com> <1404728173-20263-2-git-send-email-antoine.tenart@free-electrons.com> <53BBE419.8080107@ti.com>
In-Reply-To: <53BBE419.8080107@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2014 02:29 PM, Kishon Vijay Abraham I wrote:
> On Monday 07 July 2014 03:46 PM, Antoine Ténart wrote:
>> The Berlin SoC has a two SATA ports. Add a PHY driver to handle them.
>>
>> The mode selection can let us think this PHY can be configured to fit
>> other purposes. But there are reasons to think the SATA mode will be
>> the only one usable: the PHY registers are only accessible indirectly
>> through two registers in the SATA range, the PHY seems to be integrated
>> and no information tells us the contrary. For these reasons, make the
>> driver a SATA PHY driver.
>
> Thanks for doing multiple revisions of this. Looks good to be merged for me now.

I'd like to see some Acked-by from Tejun on the AHCI patches first, but
if he agrees, should I prepare a stable branch for each of us to pull
their patches from?

AFAIKS, that would be 1+2 for you, 3-5 for Tejun, and the DT crap 6+7
for me.

Sebastian

