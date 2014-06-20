Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967196AbaFTWd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 18:33:29 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:50020 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196AbaFTWd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 18:33:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140620185241.GC21711@titan.lakedaemon.net>
References: <1403196043-6317-1-git-send-email-gregory.clement@free-electrons.com>
 <20140620185241.GC21711@titan.lakedaemon.net>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 20 Jun 2014 17:33:06 -0500
Message-ID: <CAL_JsqKinUvcJ+OOoD70zD6CH393cgZWC+4gRO=8XORyE6fVKA@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: mvebu: Fix missing binding documentation for
 Armada 38x
To: Jason Cooper <jason@lakedaemon.net>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 1:52 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> On Thu, Jun 19, 2014 at 06:40:43PM +0200, Gregory CLEMENT wrote:
>> For the Armada 380 and Armada 385 SoCs, the common bindings for those
>> 2 SoCs, was forgotten. This patch add the documentation for the
>> marvell,aramda38x property.
>>
>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>> --
>> Hi,
>>
>> This fix should be merged in 3.16. For 3.15 I am not sure as it is not
>> a regression.
>>
>> Changelog:
>> v1->v2
>>
>> - Reformulate to make clear that we will need marvell,armada38x _and_ a
>> SoC specific string. For consistency I duplicated what we have done in
>> armada-370-xp.txt
>>
>>
>> Thanks,
>> Gregory
>>
>>
>>  Documentation/devicetree/bindings/arm/armada-38x.txt | 17 +++++++++++++++--
>>  1 file changed, 15 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/armada-38x.txt b/Documentation/devicetree/bindings/arm/armada-38x.txt
>> index 11f2330a6554..fa08760046df 100644
>> --- a/Documentation/devicetree/bindings/arm/armada-38x.txt
>> +++ b/Documentation/devicetree/bindings/arm/armada-38x.txt
>> @@ -6,5 +6,18 @@ following property:
>>
>>  Required root node property:
>>
>> - - compatible: must contain either "marvell,armada380" or
>> -   "marvell,armada385" depending on the variant of the SoC being used.
>> +compatible: must contain "marvell,armada38x"
>
> I agree with Sergei on this one.  We generally avoid wildcards in
> compatible strings.  Is there a use case where specifying one of the
> below wouldn't be sufficient?

Isn't this a case of just documenting what is already in use?

I agree wildcards alone are not good, but along with a specific
compatible is okay. But also there should be some need to have the
common property.

Rob
