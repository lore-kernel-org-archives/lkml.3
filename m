Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbaGHNOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:14:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45662 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbaGHNOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:14:18 -0400
Message-ID: <53BBEE76.7090100@ti.com>
Date: Tue, 8 Jul 2014 18:43:26 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        <tj@kernel.org>
CC: <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-ide@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/7] phy: add a driver for the Berlin SATA PHY
References: <1404728173-20263-1-git-send-email-antoine.tenart@free-electrons.com> <1404728173-20263-2-git-send-email-antoine.tenart@free-electrons.com> <53BBE419.8080107@ti.com> <53BBEB84.50904@gmail.com>
In-Reply-To: <53BBEB84.50904@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 08 July 2014 06:30 PM, Sebastian Hesselbarth wrote:
> On 07/08/2014 02:29 PM, Kishon Vijay Abraham I wrote:
>> On Monday 07 July 2014 03:46 PM, Antoine Ténart wrote:
>>> The Berlin SoC has a two SATA ports. Add a PHY driver to handle them.
>>>
>>> The mode selection can let us think this PHY can be configured to fit
>>> other purposes. But there are reasons to think the SATA mode will be
>>> the only one usable: the PHY registers are only accessible indirectly
>>> through two registers in the SATA range, the PHY seems to be integrated
>>> and no information tells us the contrary. For these reasons, make the
>>> driver a SATA PHY driver.
>>
>> Thanks for doing multiple revisions of this. Looks good to be merged for me now.
> 
> I'd like to see some Acked-by from Tejun on the AHCI patches first, but
> if he agrees, should I prepare a stable branch for each of us to pull
> their patches from?

I don't think that's needed. As long as there are no build breaks, each of us
should be able to take it independently.
> 
> AFAIKS, that would be 1+2 for you, 3-5 for Tejun, and the DT crap 6+7
> for me.

right, I'll take 1 and 2 in my tree.

Cheers
Kishon
