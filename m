Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbaDXQHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:07:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47560 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758704AbaDXQG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:06:57 -0400
Message-ID: <53593689.3060801@ti.com>
Date: Thu, 24 Apr 2014 11:06:33 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Darren Etheridge <detheridge@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, <devicetree@vger.kernel.org>,
        Rajendra Nayak <rnayak@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2 00/19] bus: omap_l3_noc: driver cleanups and support
 for DRA7/AM4372
References: <1397492726-17203-1-git-send-email-nm@ti.com> <1397767775-10965-1-git-send-email-nm@ti.com> <20140424155403.GA29229@ti.com>
In-Reply-To: <20140424155403.GA29229@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 10:54 AM, Darren Etheridge wrote:
> Nishanth,
> 
> Nishanth Menon <nm@ti.com> wrote on Thu [2014-Apr-17 15:49:16 -0500]:
>>
>> V2 introduces the following changes:
>> 	- Additional bug fix detected during additional testing (all tests complete now). patch #12
>> 	- reordering of patches to order logical changes and reduce code churn.
>> 	- interrupt handler split up and additional information now provided in log to aid debug when error occur
>> 	- patches are marked where new (12,14,15,16).
>> 	- DRA7 updated from master document for all DRA7 variants.
>>
>> This series cleansup omap_l3_noc driver and adds data to support DRA7
>> and AM437x SoCs.
>>
> This L3 noc driver patch series is working great for me and has already
> flagged a very difficult to detect problem in a driver I am working on
> with a DMA access to an invalid memory address on DRA7.

Glad it was of use. All the more reason why this should be in upstream
kernel and not just in "evil vendor" kernel.

> 
> Tested-by: Darren Etheridge <detheridge@ti.com>
> 
Thanks. will pick this up for v3 post.


-- 
Regards,
Nishanth Menon
