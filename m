Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaLANHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:07:39 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:57856 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaLANHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:07:37 -0500
Message-ID: <547C6828.6010702@gmail.com>
Date: Mon, 01 Dec 2014 21:07:52 +0800
From: Zhou Wang <wangzhou.bry@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
        galak@codeaurora.org, caizhiyong@huawei.com, haojian.zhuang@gmail.com,
        xuwei5@hisilicon.com, wangzhou1@hisilicon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] mtd: hisilicon: add device tree binding documentation
References: <1415105221-7732-1-git-send-email-wangzhou.bry@gmail.com> <1415105221-7732-3-git-send-email-wangzhou.bry@gmail.com> <20141130090106.GF3608@norris-Latitude-E6410>
In-Reply-To: <20141130090106.GF3608@norris-Latitude-E6410>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年11月30日 17:01, Brian Norris wrote:
> One more thing:
>
> On Tue, Nov 04, 2014 at 08:47:01PM +0800, Zhou Wang wrote:
>> diff --git a/Documentation/devicetree/bindings/mtd/hisi504-nand.txt b/Documentation/devicetree/bindings/mtd/hisi504-nand.txt
>> new file mode 100644
>> index 0000000..c8b3988
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mtd/hisi504-nand.txt
>> @@ -0,0 +1,40 @@
>> +Hisilicon Hip04 Soc NAND controller DT binding
>> +
>> +Required properties:
>> +- compatible:          Should be "hisilicon,504-nfc".
>
> I notice you use "NFC" naming throughout. I know others have had
> complaints about overloading the acronym NFC which sometimes means "Near
> Field Communication", instead of the intended "NAND Flash Controller."
> Is there any kind of naming convention within Hisilicon documentation
> that insists on calling this NFC, or can we avoid that confusing name?
>
> If possible, I'd suggest "hisilicon,504-nand" as an alternative.
>

I think that is a good idear to call "hisilicon,504-nand", in fact, at
the beginning, I also confused with the name "nfc".

> Brian
>

Thanks,
Zhou Wang


