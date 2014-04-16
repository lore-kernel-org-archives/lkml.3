Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161339AbaDPOE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:04:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55630 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161077AbaDPOEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:04:24 -0400
Message-ID: <534E8DA1.8090101@ti.com>
Date: Wed, 16 Apr 2014 10:03:13 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Brian Norris <computersforpeace@gmail.com>
CC: <dwmw2@infradead.org>, <galak@codeaurora.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <grygorii.strashko@ti.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <m-karicheri2@ti.com>,
        Warner Losh <imp@bsdimp.com>
Subject: Re: [PATCH v2] mtd: davinci-nand: disable subpage write for keystone-nand
References: <1395346112-13350-1-git-send-email-ivan.khoronzhuk@ti.com> <532B4C36.8060405@ti.com> <5343F0D6.2010804@ti.com> <20140416070833.GA5512@norris-Latitude-E6410> <534E51BF.9050508@ti.com>
In-Reply-To: <534E51BF.9050508@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 April 2014 05:47 AM, Ivan Khoronzhuk wrote:
> 
> On 04/16/2014 10:08 AM, Brian Norris wrote:
>> On Tue, Apr 08, 2014 at 03:51:34PM +0300, Ivan Khoronzhuk wrote:
>>> On 03/20/2014 10:14 PM, Santosh Shilimkar wrote:
>>>> On Thursday 20 March 2014 04:08 PM, Ivan Khoronzhuk wrote:
>>>>> From: Murali Karicheri <m-karicheri2@ti.com>
>>>>> Sub page write doesn't work because of hw issue in controller found on
>>>>> Keystone SOCs. AEMIF controller is also used on DaVinci SOCs which
>>>>> don't seems to have any issue. So add "ti,keysone-nand" compatible
>>>>> to nand driver in order to set NAND_NO_SUBPAGE_WRITE option.
>>>>>
>>>>> Cc: Brian Norris <computersforpeace@gmail.com>
>>>>> Cc: Warner Losh <imp@bsdimp.com>
>>>>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>>>>
>>>>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>>>>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>>>>> ---
>>>>>
>>>> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>> Brian,
>>> Could you pick up subj patch?
>> Pushed to l2-mtd.git. Is it critical this goes in for 3.15? It's
>> currently queued for -next (3.16).
>>
>> Brian
> 
> This is a critical fix and it should be for 3.15.
Yep. The NAND is broken on Keystone without this patch.
So 3.15 fixes please

Regards,
Santosh

