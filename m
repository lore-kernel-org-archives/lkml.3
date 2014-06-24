Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaFXFGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 01:06:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54068 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaFXFGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 01:06:05 -0400
Message-ID: <53A90735.7050506@ti.com>
Date: Tue, 24 Jun 2014 10:35:57 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>
CC: Roger Quadros <rogerq@ti.com>, <tony@atomide.com>, <rnayak@ti.com>,
        <nm@ti.com>, <kishon@ti.com>, <george.cherian@ti.com>, <balbi@ti.com>,
        <balajitk@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] ARM: DRA7: hwmod: fixes for 3.16
References: <1403093816-10960-1-git-send-email-rogerq@ti.com> <alpine.DEB.2.02.1406230450460.27636@utopia.booyaka.com> <53A83DAC.6050504@ti.com> <alpine.DEB.2.02.1406231634210.29849@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.02.1406231634210.29849@utopia.booyaka.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2014 10:04 PM, Paul Walmsley wrote:
> On Mon, 23 Jun 2014, Sekhar Nori wrote:
> 
>> On Monday 23 June 2014 10:27 AM, Paul Walmsley wrote:
>>> Hi Roger
>>>
>>> On Wed, 18 Jun 2014, Roger Quadros wrote:
>>>
>>>> These patches add the missing OCP2SCP3 module and fixup the SATA hwmod
>>>> for DRA7 SoC. Both patches are tested on 3.16-rc1.
>>>
>>> Could you please post a quick serial capture of a boot log for these 
>>> patches, as Felipe has done for other patches?
>>
>> Roger is OOO so posting the logs on his behalf.
>>
>> $ git log -3
>> 3e0ca738 4 minutes ago  (HEAD) ARM: DRA7: hwmod: Add OCP2SCP3 module
>> 9961b81 4 minutes ago  ARM: DRA7: hwmod: Fixup SATA hwmod
>> 7171511 7 days ago  (v3.16-rc1, linus-git/master) Linux 3.16-rc1
>>
>> Attached is the minicom capture.
> 
> Thanks, so can I add your Tested-by: ?

Sure Paul.

Tested-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar
