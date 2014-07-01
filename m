Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbaGAXwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 19:52:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15133 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759256AbaGAXwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 19:52:18 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-65-53b349b0a1fe
Message-id: <53B349AF.4080606@samsung.com>
Date: Wed, 02 Jul 2014 08:52:15 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sachin Kamat <spk.linux@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: Add TMU dt node to monitor the temperature for
 Exynos3250
References: <1404175210-9278-1-git-send-email-cw00.choi@samsung.com>
 <CAK5sBcFJMK-y+MZPXCufKEmp=v1nFJHstvNTczsQ3ez3SUPbKw@mail.gmail.com>
 <53B23362.7080103@samsung.com>
 <CAK5sBcER-rFmqe74b8uS=ZxKnTNGtkE0x6f7zaLphmyuHJz7Yg@mail.gmail.com>
In-reply-to: <CAK5sBcER-rFmqe74b8uS=ZxKnTNGtkE0x6f7zaLphmyuHJz7Yg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsWyRsSkWHeD5+Zgg5NLuS0mrTvAZDH/yDlW
	i/43C1ktzr1ayWjRu+Aqm8XZpjfsFpseX2O1uLxrDpvFjPP7mCxuX+a1WHr9IpPFhOlrWSxa
	9x5ht2j5eo7FYv2M1ywO/B5r5q1h9Ghp7mHzuNzXy+Txd9ULZo+ds+6ye6xc/oXNY9OqTjaP
	zUvqPfq2rGL0+LxJLoArissmJTUnsyy1SN8ugSvj2iLLgi3CFTcPnWJvYNzN18XIySEhYCKx
	e9kJVghbTOLCvfVsXYxcHEICSxkl5q55wwJT1Px4MytEYjqjxO2FT9hAEkICrxkl5t0WALF5
	BbQk9k7fzwxiswioSlyfcQqshg0ovv/FDTBbVCBMYuX0KywQ9YISPybfA7NFBNQkZp49DbaZ
	WeAri8Sa9t2MXYwcHMICURK7DkHt+swo8WA2E4jNKRAs0dP6EKyXWUBdYtK8RcwQtrzE5jVv
	mUHmSAis5JCYvGY+G8RBAhLfJh9iAZkpISArsekAM8RjkhIHV9xgmcAoNgvJSbOQjJ2FZOwC
	RuZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIExf/rfs74djDcPWB9iTAZaOZFZSjQ5H5gy
	8kriDY3NjCxMTUyNjcwtzUgTVhLnXfQwKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo5/a
	dPFOrYVZrr2a585fPnenpqn54bm0y5sTLn/OCuufmu0fzG/a3t3ZXCCxqX+5Q5/12mhTny2M
	6bNdjHV+fuVzdrSMWKxfI9l9fkfH9ci15jvueX89I+P/ZYVtV0SZjLvdpKJsjS979Cz8NrGs
	T5kXJbzpeJfVz01/zSpv7Gs5HhWz7Od1JZbijERDLeai4kQAEmhNeA8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jQd0NnpuDDSatZbKYtO4Ak8X8I+dY
	LfrfLGS1OPdqJaNF74KrbBZnm96wW2x6fI3V4vKuOWwWM87vY7K4fZnXYun1i0wWE6avZbFo
	3XuE3aLl6zkWi/UzXrM48HusmbeG0aOluYfN43JfL5PH31UvmD12zrrL7rFy+Rc2j02rOtk8
	Ni+p9+jbsorR4/MmuQCuqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygN5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGdcW
	WRZsEa64eegUewPjbr4uRk4OCQETiebHm1khbDGJC/fWs3UxcnEICUxnlLi98AkbSEJI4DWj
	xLzbAiA2r4CWxN7p+5lBbBYBVYnrM06B1bABxfe/uAFmiwqESaycfoUFol5Q4sfke2C2iICa
	xMyzp8EWMAt8ZZFY076bsYuRg0NYIEpi1yGoXZ8ZJR7MZgKxOQWCJXpaH4L1MguoS0yat4gZ
	wpaX2LzmLfMERoFZSFbMQlI2C0nZAkbmVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBCeWZ
	1A7GlQ0WhxgFOBiVeHgj7m4KFmJNLCuuzD3EKMHBrCTCG8+zOViINyWxsiq1KD++qDQntfgQ
	oykwBCYyS4km5wOTXV5JvKGxiZmRpZG5oYWRsbmSOO+BVutAIYH0xJLU7NTUgtQimD4mDk6p
	BsbNx7SvZ9avdPD//OV0d7z2ocmce4Pibn02jS5pltE93PCKYVHYgRNRjTOVn7u3hbi/0Hx9
	3/bmWr8p7zMeCc95rfPl8+doB/0Sr961EuZ1Ph9+sv46Kb6yrUFQQeNoVXOjvbFjQTu38ltD
	qQJJ7u7edbxzIqaeMok+yFt295Hn0uBnv2dlvldiKc5INNRiLipOBACR4K+aPgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 01:10 PM, Sachin Kamat wrote:
> Hi Chanwoo,
> 
> On Tue, Jul 1, 2014 at 9:34 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> Hi Sachin,
>>
>> On 07/01/2014 12:33 PM, Sachin Kamat wrote:
>>> Hi Chanwoo,
>>>
>>> On Tue, Jul 1, 2014 at 6:10 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>>> This patch add TMU (Thermal Management Unit) dt node to monitor the high
>>>> temperature for Exynos3250.
>>>>
>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> ---
>>>> This patch has a dependency on following patch [1]:
>>>>  [1] https://lkml.org/lkml/2014/6/30/805
>>>>
>>>>  arch/arm/boot/dts/exynos3250.dtsi | 10 ++++++++++
>>>>  1 file changed, 10 insertions(+)
>>>>
>>>> diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
>>>> index 3660cab..1e566af 100644
>>>> --- a/arch/arm/boot/dts/exynos3250.dtsi
>>>> +++ b/arch/arm/boot/dts/exynos3250.dtsi
>>>> @@ -192,6 +192,16 @@
>>>>                         status = "disabled";
>>>>                 };
>>>>
>>>> +               tmu: tmu@100C0000 {
>>>> +                       compatible = "samsung,exynos3250-tmu";
>>>> +                       interrupt-parent = <&gic>;
>>>> +                       reg = <0x100C0000 0x100>;
>>>> +                       interrupts = <0 216 0>;
>>>> +                       clocks = <&cmu CLK_TMU_APBIF>;
>>>> +                       clock-names = "tmu_apbif";
>>>> +                       status = "disabled";
>>>
>>> I don't think there would be any board specific properties needed. Hence
>>> leave the status as enabled (by deleting the above line).
>>>
>>
>> I think that if specific board need TMU feature, dts file for specific board
>> should include tmu dt node with 'okay' status. The specific board based on
>> Exynos3250 might not need TMU feature.
> 
> The status field in DT node is not meant for stating the build configuration but
> represents the readiness of the hardware for usage on the platform. If
> a particular
> board does not need this feature it needs to be disabled in the build
> config and only
> for any special requirements disable it in board file.

TMU (Thermal Management Unit) needs specific regulator for TMU power as following:
The regulator for TMU is dependent on board.

For exmaple: in board dts file including tmu dt

	&tmu {
		vtmu-supply = <&ldo7_reg>;
		status = "okay";
	};


