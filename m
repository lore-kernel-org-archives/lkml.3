Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbaK0L31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:29:27 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:11310 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbaK0L3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:29:24 -0500
X-AuditID: cbfee68e-f79b46d000002b74-9b-54770b10ac71
Message-id: <54770B10.3050804@samsung.com>
Date: Thu, 27 Nov 2014 20:29:20 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "olof@lixom.net" <olof@lixom.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "s.nawrocki@samsung.com" <s.nawrocki@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "chanho61.park@samsung.com" <chanho61.park@samsung.com>,
        "geunsik.lim@samsung.com" <geunsik.lim@samsung.com>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        "jh80.chung@samsung.com" <jh80.chung@samsung.com>,
        "a.kesavan@samsung.com" <a.kesavan@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 02/19] clk: samsung: Add binding documentation for
 Exynos5433 clock controller
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
 <1417073716-22997-3-git-send-email-cw00.choi@samsung.com>
 <20141127112113.GC857@leverpostej>
In-reply-to: <20141127112113.GC857@leverpostej>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsWyRsSkQFeQuzzEYOkJNovHaxYzWfyddIzd
	4v2yHkaLy/u1LeYfOcdq8WdCK5vFpPsTWCxu/GpjtehdcJXN4mzTG3aLKX+WM1lsenyN1eLy
	rjlsFjPO72OyWHr9IpPFqeuf2SwOv2lntZgx+SWbxbEZSxgtVu36w2jx8uMJFgdRjzXz1jB6
	/P41idFj56y77B53ru1h89i8pN7jyokmVo++LasYPT5vkgvgiOKySUnNySxLLdK3S+DK6J69
	la3gk0RF/4frTA2Mt0S6GDk5JARMJGavesAIYYtJXLi3nq2LkYtDSGApo8TBU+fYYIp2HL7E
	DpFYxChx5+xZRgjnNaPEhStf2UGqeAW0JBY9ecgKYrMIqEr8PfAcLM4GFN//4gbYJFGBMImV
	06+wQNQLSvyYfA/MFhFQl+jZ9YUFZCizwC4Oibb3EDcJC6RIbLg3nRli2zJGiaeTvjKBJDgF
	9CU6TnWCdTML6Ejsb53GBmHLS2xe8xasQULgDIfElSUQ61gEBCS+TT4EZHMAJWQlNh1ghvhN
	UuLgihssExjFZiE5ahaSsbOQjF3AyLyKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIzBFnP73
	rG8H480D1ocYBTgYlXh4LQ6UhQixJpYVV+YeYjQFumIis5Rocj4wEeWVxBsamxlZmJqYGhuZ
	W5opifMmSP0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cAoyGtj3fr/jnp11o9n07ZqqOvO
	TstdtGW++vUd/y/kLM3i+m0Wciv8zuzQ0jCpDEkl+WkfJpj8zK97vErSulxY+Lhh1Io/R64d
	vy0YYNYvt0zQrf9zHXNQj6DfTvnYl5cCPvYXTNS52HFQRfzxpJrMw2w3F/Mq6O5XbarhPNFs
	8WL72x7vQE4lluKMREMt5qLiRAD/+v1yDAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jAV0B7vIQgz1PLS0er1nMZPF30jF2
	i/fLehgtLu/Xtph/5ByrxZ8JrWwWk+5PYLG48auN1aJ3wVU2i7NNb9gtpvxZzmSx6fE1VovL
	u+awWcw4v4/JYun1i0wWp65/ZrM4/Kad1WLG5JdsFsdmLGG0WLXrD6PFy48nWBxEPdbMW8Po
	8fvXJEaPnbPusnvcubaHzWPzknqPKyeaWD36tqxi9Pi8SS6AI6qB0SYjNTEltUghNS85PyUz
	L91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6DUlhbLEnFKgUEBicbGSvh2mCaEh
	broWMI0Rur4hQXA9RgZoIGENY0b37K1sBZ8kKvo/XGdqYLwl0sXIySEhYCKx4/AldghbTOLC
	vfVsXYxcHEICixgl7pw9ywjhvGaUuHDlK1gVr4CWxKInD1lBbBYBVYm/B56DxdmA4vtf3GAD
	sUUFwiRWTr/CAlEvKPFj8j0wW0RAXaJn1xcWkKHMArs4JNreP2AESQgLpEhsuDedGWLbMkaJ
	p5O+MoEkOAX0JTpOdYJ1MwvoSOxvncYGYctLbF7zlnkCo8AsJEtmISmbhaRsASPzKkbR1ILk
	guKk9FxDveLE3OLSvHS95PzcTYzgBPRMagfjygaLQ4wCHIxKPLwWB8pChFgTy4orcw8xSnAw
	K4nwcjGWhwjxpiRWVqUW5ccXleakFh9iNAWGwURmKdHkfGByzCuJNzQ2MTOyNDI3tDAyNlcS
	571xMzdESCA9sSQ1OzW1ILUIpo+Jg1OqgbFb53uPgo+jbMq1kuzPGhu/PbpWefZ74MeYouIe
	g+0nrzF+Pmcy4/pX8Xn6zjdK/mUmmhTLLN8i9He5DO/StlAXw6DbmufeSD94/I/vp3ONXcFt
	1yKF34duebwqnhbW/0shdVqaxKxTZ6bf/cQfl/ZsyhefZgtez6evrXue7WL+G5pxzPT6+7NK
	LMUZiYZazEXFiQDBkF4+VgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mark,

On 11/27/2014 08:21 PM, Mark Rutland wrote:
> On Thu, Nov 27, 2014 at 07:34:59AM +0000, Chanwoo Choi wrote:
>> This patch add binding documentation for Exynos5433 clock controller.
>> Exynos5433 has various clock domains So, this documentation explains
>> the detailed clock domains ans usage guide.
>>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Tomasz Figa <tomasz.figa@gmail.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Inki Dae <inki.dae@samsung.com>
>> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
>> ---
>>  .../devicetree/bindings/clock/exynos5433-clock.txt | 106 +++++++++++++++++++++
>>  1 file changed, 106 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/clock/exynos5433-clock.txt
>>
>> diff --git a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
>> new file mode 100644
>> index 0000000..72cd0ba
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
>> @@ -0,0 +1,106 @@
>> +* Samsung Exynos5433 CMU (Clock Management Units)
>> +
>> +The Exynos5433 clock controller generates and supplies clock to various
>> +controllers within the Exynos5433 SoC.
>> +
>> +Required Properties:
>> +
>> +- compatible: should be one of the following.
>> +  - "samsung,exynos5433-cmu-top"   - clock controller compatible for CMU_TOP
>> +    which generates clocks for IMEM/FSYS/G3D/GSCL/HEVC/MSCL/G2D/MFC/PERIC/PERIS
>> +    domains and bus clocks.
>> +  - "samsung,exynos5433-cmu-cpif"  - clock controller compatible for CMU_CPIF
>> +    which generates clocks for LLI (Low Latency Interface) IP.
>> +  - "samsung,exynos5433-cmu-mif"   - clock controller compatible for CMU_MIF
>> +    which generates clocks for DRAM Memory Controller domain.
>> +  - "samsung,exynos5433-cmu-peric" - clock controller compatible for CMU_PERIC
>> +    which generates clocks for UART/I2C/SPI/I2S/PCM/SPDIF/PWM/SLIMBUS IPs.
>> +  - "samsung,exynos5433-cmu-peris" - clock controller compatible for CMU_PERIS
>> +    which generates clocks for PMU/TMU/MCT/WDT/RTC/SECKEY/TZPC IPs.
>> +  - "samsung,exynos5433-cmu-fsys"  - clock controller compatible for CMU_FSYS
>> +    which generates clocks for USB/UFS/SDMMC/TSI/PDMA IPs.
>> +
>> +- reg: physical base address of the controller and length of memory mapped
>> +  region.
>> +
>> +- #clock-cells: should be 1.
>> +
>> +Each clock is assigned an identifier and client nodes can use this identifier
>> +to specify the clock which they consume.
>> +
>> +All available clocks are defined as preprocessor macros in
>> +dt-bindings/clock/exynos5433.h header and can be used in device
>> +tree sources.
> 
> That header should be added as part of this patch, otehrwise this is
> incomplete.

OK, I'll merge two patches (patch2 and patch3) by solving this issue.

patch2 : [PATCH 02/19] clk: samsung: Add binding documentation for Exynos5433 clock controller
patch3 : [PATCH 03/19] clk: samsung: exynos5433: Add clocks using common clock framework

Thanks for your review.

Best Regards,
Chanwoo Choi



