Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbaIQBMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 21:12:38 -0400
Received: from regular1.263xmail.com ([211.150.99.133]:37613 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbaIQBMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 21:12:35 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <0d01e84ded65909071948277406839a0>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <5418DFFC.5030808@rock-chips.com>
Date: Wed, 17 Sep 2014 09:12:28 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "heiko@sntech.de" <heiko@sntech.de>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "sonnyrao@chromium.org" <sonnyrao@chromium.org>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "xjq@rock-chips.com" <xjq@rock-chips.com>,
        "hj@rock-chips.com" <hj@rock-chips.com>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jason Cooper <jason@lakedaemon.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Olof Johansson <olof@lixom.net>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] Documentation: dt-bindings: add dt binding info
 for rk3288-smp
References: <1410864271-9277-1-git-send-email-kever.yang@rock-chips.com> <1410864271-9277-2-git-send-email-kever.yang@rock-chips.com> <20140916185439.GF14191@leverpostej>
In-Reply-To: <20140916185439.GF14191@leverpostej>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

     Thanks for your comment.
On 09/17/2014 02:54 AM, Mark Rutland wrote:
> On Tue, Sep 16, 2014 at 11:44:28AM +0100, Kever Yang wrote:
>> This add documentation for rk3288 smp dt binding
>>
>> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
>> ---
>>
>> Changes in v2:
>> - add documentation
>>
>>   Documentation/devicetree/bindings/arm/cpus.txt | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
>> index 298e2f6..4b46233 100644
>> --- a/Documentation/devicetree/bindings/arm/cpus.txt
>> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
>> @@ -195,6 +195,7 @@ nodes to be present and contain the properties described below.
>>   			    "qcom,kpss-acc-v1"
>>   			    "qcom,kpss-acc-v2"
>>   			    "rockchip,rk3066-smp"
>> +			    "rockchip,rk3288-smp"
> How do these differ?
rk3066 and rk3288 smp bring up code is quite different, so I need a new 
node "rockchip,rk3288-smp"
other than "rockchip,rk3066-smp".
>
> What does "rockchip,rk3288-smp" mean exactly?
The driver who using this node is in 2/3 of this patchset, it goes to 
linux-arm-kernel list and linux-rockchip
list, I'm not sure if you have get that, maybe I need a RESEND?
>
> Presumably other nodes / properties are required?
Base on linux-next, I think only "rockchip,rk3288-smp" is new node to my 
driver.

BR
-Kever

