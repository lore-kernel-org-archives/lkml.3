Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab3JHRIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 13:08:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42718 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3JHRIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 13:08:51 -0400
Message-ID: <52543C1B.3000403@wwwdotorg.org>
Date: Tue, 08 Oct 2013 11:08:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, Laxman Dewangan <ldewangan@nvidia.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        J Keerthy <j-keerthy@ti.com>
Subject: Re: [PATCH V3] clk: palmas: add clock driver for palmas
References: <1381238480-18852-1-git-send-email-ldewangan@nvidia.com> <525408B3.1000107@ti.com> <5254193A.70104@nvidia.com> <52542F69.30407@ti.com>
In-Reply-To: <52542F69.30407@ti.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 10:14 AM, Nishanth Menon wrote:
> On 10/08/2013 09:39 AM, Laxman Dewangan wrote:
>> Thanks Nishanth for review.
>>
>> On Tuesday 08 October 2013 06:59 PM, Nishanth Menon wrote:
>>> On 10/08/2013 08:21 AM, Laxman Dewangan wrote:
>>>> Palmas devices has two clock output CLK32K_KG and CLK32K_KG_AUDIO
>>> not all palmas devices have 2 clocks - example: tps659038
>>
>> This is for generic palmas and I have seen it for TPS65913, TPS65914, 
>> TPS80036. If the generic one is not compatible then it need to add  
>> device specific and at that time, it is require to update the binding 
>> document accordingly.
> 
> ?? you do have two clocks inside the device they should be represented
> as two compatible entities - that simplifies everyone's life.

I think the terminology you're using here is quite confusing.

Are you talking about having two different compatible values for two
different HW designs, where those different designs implement different
sets of clocks (which makes sense), or two different DT nodes for two
different clocks (which IMHO doesn't always, unless those different
clocks *truly* are separate IP blocks with completely independent
register regions, and where those IP blocks are likely to be re-used
as-is in other chips).

