Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbaI0NJK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 09:09:10 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:53822 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaI0NJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 09:09:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140925133609.GK15315@lukather>
References: <1411570141-29960-1-git-send-email-wens@csie.org>
 <1411570141-29960-7-git-send-email-wens@csie.org> <20140925133609.GK15315@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Sat, 27 Sep 2014 21:08:46 +0800
X-Google-Sender-Auth: YjMS_lwIt-jZjD4fcnMZTolIN5M
Message-ID: <CAGb2v65pKo=6BC-HaMsEMq-bcQcoHZNc9GiX+kfTBgP1PE5wMg@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] devicetree: bindings: Document supported Allwinner
 sunxi SoCs
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        ctl <ctl@merrii.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 9:36 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Wed, Sep 24, 2014 at 10:49:00PM +0800, Chen-Yu Tsai wrote:
>> This adds a list of supported Allwinner SoC bindings.
>>
>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> ---
>>  Documentation/devicetree/bindings/arm/sunxi.txt | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/arm/sunxi.txt
>>
>> diff --git a/Documentation/devicetree/bindings/arm/sunxi.txt b/Documentation/devicetree/bindings/arm/sunxi.txt
>> new file mode 100644
>> index 0000000..d7d1039
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/sunxi.txt
>> @@ -0,0 +1,12 @@
>> +Allwinner sunXi Platforms Device Tree Bindings
>> +
>> +Each device tree must specify which Allwinner SoC it uses,
>> +using one of the following compatible stirngs:
>                                          ^ strings

Will fix.

>> +
>> +  allwinner,sun4i-a10
>> +  allwinner,sun5i-a10s
>> +  allwinner,sun5i-a13
>> +  allwinner,sun6i-a31
>> +  allwinner,sun7i-a20
>> +  allwinner,sun8i-a23
>> +  allwinner,sun9i-a80
>
> Maybe you can just add this info to the already existing README?

AFAIK the bindings are where they're supposed to be.

Putting the bindings outside of devicetree/bindings is unexpected
and confusing.


Cheers
ChenYu
