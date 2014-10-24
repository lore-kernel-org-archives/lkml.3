Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbaJXKfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:35:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10830 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbaJXKe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:34:56 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-f0-544a2b4ea241
Message-id: <544A2B4E.8090604@samsung.com>
Date: Fri, 24 Oct 2014 19:34:54 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        ben-linux@fluff.org, linux@arm.linux.org.uk, mark.rutland@arm.com,
        arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        mturquette@linaro.org, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        geunsik.lim@samsung.com, jh80.chung@samsung.com,
        jaewon02.kim@samsung.com, ideal.song@samsung.com, yj44.cho@samsung.com
Subject: Re: [PATCH 3/5] clk: samsung: Document binding for Exynos4415 clock
 controller
References: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>
 <1413775935-17743-3-git-send-email-cw00.choi@samsung.com>
 <544A2AA5.3020407@samsung.com>
In-reply-to: <544A2AA5.3020407@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42JZI2JSouun7RVicGy7lsXfScfYLSatO8Bk
	8WdCK5vFrr/3GS0m3Z/AYrGj4QirxY1fbawWvQuuslmcbXrDbjHlz3Imi02Pr7FaXN41h81i
	xvl9TBa3L/NaLL1+kcni6YSLbBanrn9mszj8pp3VYsbkl2wWx2YsYbRYtesPo8XenZMZHcQ8
	1sxbw+jR0tzD5vH71yRGj7+rXjB77Jx1l93jzrU9bB6bl9R7XDnRxOrRt2UVo8fnTXIBXFFc
	NimpOZllqUX6dglcGVe3LWUqmKFQ8XdeO1sD41fJLkZODgkBE4k5PxawQdhiEhfurQeyuTiE
	BJYySpxet5EFpujAt8esEInpjBLLrr5hhnBeM0p8P/6XGaSKV0BLYtGPHYwgNouAqsSMY21g
	Y9mA4vtf3ACzRQXCJFZOv8ICUS8o8WPyPTBbREBfYsmqi2A1zAJTWST+vjMBsYUFIiV2fPsO
	tXkRo8TBjV/YQRKcAtoSh/58Y+pi5ABq0JO4f1ELoldeYvOat2DHSQg84JC41juZHeIgAYlv
	kw+xgNRLCMhKbDrADPGZpMTBFTdYJjCKzUJy0iyEqbOQTF3AyLyKUTS1ILmgOCm9yESvODG3
	uDQvXS85P3cTIzB1nP73bMIOxnsHrA8xCnAwKvHwGsz2DBFiTSwrrsw9xGgKdMREZinR5Hxg
	gsoriTc0NjOyMDUxNTYytzRTEud9LfUzWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjwjPK
	Z4sy1yhqSylxPhT5abm7cYpMhZXpi58B0+pyWg459X8s1vGcOin4fpNKZ9SdZpH3PjvMPD4u
	lTbP/HtEY/FjbX1DfeM95T1Mn+XvbcuuWr6pV82BeavbtccdCV8vX7k7yVXaz8N8ToXTU5n3
	l9Kkee9VyEztvXN6xsqfKgc+qtquZjupxFKckWioxVxUnAgAFkq0sRgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsVy+t9jQV0/ba8Qg1eNChZ/Jx1jt5i07gCT
	xZ8JrWwWu/7eZ7SYdH8Ci8WOhiOsFjd+tbFa9C64ymZxtukNu8WUP8uZLDY9vsZqcXnXHDaL
	Gef3MVncvsxrsfT6RSaLpxMuslmcuv6ZzeLwm3ZWixmTX7JZHJuxhNFi1a4/jBZ7d05mdBDz
	WDNvDaNHS3MPm8fvX5MYPf6uesHssXPWXXaPO9f2sHlsXlLvceVEE6tH35ZVjB6fN8kFcEU1
	MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAH2qpFCW
	mFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcy4um0pU8EMhYq/89rZGhi/SnYx
	cnJICJhIHPj2mBXCFpO4cG89WxcjF4eQwHRGiWVX3zBDOK8ZJb4f/8sMUsUroCWx6McORhCb
	RUBVYsaxNjYQmw0ovv/FDTBbVCBMYuX0KywQ9YISPybfA7NFBPQllqy6CFbDLDCVReLvOxMQ
	W1ggUmLHt++sEMsWMUoc3PiFHSTBKaAtcejPN6YuRg6gBj2J+xe1IHrlJTavecs8gVFgFpIV
	sxCqZiGpWsDIvIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjODE9k9rBuLLB4hCjAAejEg/v
	jRmeIUKsiWXFlbmHGCU4mJVEeF+qeYUI8aYkVlalFuXHF5XmpBYfYjQFBsBEZinR5Hxg0swr
	iTc0NjEzsjQyN7QwMjZXEuc90GodKCSQnliSmp2aWpBaBNPHxMEp1cCoxfZ8843aN3/VPjU8
	DvNUusYVf/C5bY7z/4+z/7319L+mcoW56+2kM3absyatMzo/w0his0eWs82GqPnO5r8W5iYw
	7jsvp3xrCWPEY8vV4czH/7/sr9spWGfLZ9Py9M46xhv1c5U3VK7qWv5338VlTn0eLBmb6h17
	6uJFWbMnzFrCdZ6Ff0m8EktxRqKhFnNRcSIAkt0ZqGIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

On 10/24/2014 07:32 PM, Sylwester Nawrocki wrote:
> On 20/10/14 05:32, Chanwoo Choi wrote:
>> The Exynos4415 clocks are statically listed and registered using the
>> Samsung specific common clock helper functions. Both device tree based
>> clock lookup and clkdev based clock lookups are supported.
> 
> I think the above text is not relevant, DT binding is not supposed
> to depend on any OS. Instead I would just put here something like:
> 
> "This patch adds DT binding documentation for Exynos4415 SoC system
> clock controllers."

OK, I will modify it as your comment.

> 
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Tomasz Figa <tomasz.figa@gmail.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  .../devicetree/bindings/clock/exynos4415-clock.txt | 49 ++++++++++++++++++++++
>>  1 file changed, 49 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/clock/exynos4415-clock.txt
>>
>> diff --git a/Documentation/devicetree/bindings/clock/exynos4415-clock.txt b/Documentation/devicetree/bindings/clock/exynos4415-clock.txt
>> new file mode 100644
>> index 0000000..8aa4f4f
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/clock/exynos4415-clock.txt
>> @@ -0,0 +1,49 @@
>> +* Samsung Exynos4415 Clock Controller
>> +
>> +The Exynos4415 clock controller generates and supplies clock to various
>> +controllers within the Exynos4415 SoC.
> 
> s/controllers/consumer devices/ ?
> 
>> +
>> +Required Properties:
> 
> s/P/p/ ?

I'll fix it.

> 
>> +
>> +- compatible: should be one of the following.
> 
> s/./:/ ?

I will change it (. -> :)

> 
>> +  - "samsung,exynos4415-cmu" - controller compatible with Exynos4415 SoC.
> 
>>From current description it seems "samsung,exynos4415-cmu-dmc" is compatible
> with "samsung,exynos4415-cmu", which is not the case AFAIK.
> Perhaps we should change description here to something along the lines of:
> 
> - "samsung,exynos4415-cmu" - for the main system clocks controller
>   (CMU_LEFTBUS, CMU_RIGHTBUS, CMU_TOP, CMU_CPU clock domains),
> 
>> +  - "samsung,exynos4415-cmu-dmc" - controller compatible with
>> +    Exynos4415 SoC for Dynamic Memory Controller domain.
> 
> This seems unclear, how about
> 
>  - "samsung,exynos4415-cmu-dmc" - for the Exynos4415 SoC DRAM Memory
>     Controller (DMC) domain clock controller.
> 
> ?

OK, I'll modify it

>> +- reg: physical base address of the controller and length of memory mapped
>> +  region.
>> +
>> +- #clock-cells: should be 1.
>> +
>> +Each clock is assigned an identifier and client nodes can use this identifier
>> +to specify the clock which they consume.
>> +
>> +All available clocks are defined as preprocessor macros in
>> +dt-bindings/clock/exynos4415.h header and can be used in device
>> +tree sources.
> 
>> +Example 1: An example of a clock controller node is listed below.
>> +
>> +	cmu: clock-controller@10030000 {
>> +		compatible = "samsung,exynos4415-cmu";
>> +		reg = <0x10030000 0x18000>;
>> +		#clock-cells = <1>;
>> +	};
>> +
>> +	cmu-dmc: clock-controller@105C0000 {
>> +		compatible = "samsung,exynos4415-cmu-dmc";
>> +		reg = <0x105C0000 0x3000>;
>> +		#clock-cells = <1>;
>> +	};
>> +
>> +Example 2: UART controller node that consumes the clock generated by the clock
>> +	   controller. Refer to the standard clock bindings for information
>> +	   about 'clocks' and 'clock-names' property.
>> +
>> +	serial_0: serial@13800000 {
>> +		compatible = "samsung,exynos4210-uart";
>> +		reg = <0x13800000 0x100>;
>> +		interrupts = <0 109 0>;
>> +		clocks = <&cmu CLK_UART0>, <&cmu CLK_SCLK_UART0>;
>> +		clock-names = "uart", "clk_uart_baud0";
>> +	};
> 
> I think we could omit those example snippets, it's all generic stuff and
> there is already plenty examples in descriptions of the DT binding for
> other SoCs.

OK, I'll drop this example.

Thanks for your review.

Best Regards,
Chanwoo Choi

> 
> --
> Regards,
> Sylwester
> 

