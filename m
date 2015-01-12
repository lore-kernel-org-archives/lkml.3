Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbbALIi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:38:56 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16562 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbbALIiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:38:52 -0500
X-AuditID: cbfee691-f79b86d000004a5a-b2-54b3881a038d
Message-id: <54B3881A.60407@samsung.com>
Date: Mon, 12 Jan 2015 17:38:50 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: myungjoo.ham@samsung.com
Cc: "kgene@kernel.org" <kgene@kernel.org>,
        =?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?UTF-8?B?64yA7J246riw?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCHv7 05/10] devfreq: event: Add documentation for exynos-ppmu
 devfreq-event driver
References: <905389780.892831421050282747.JavaMail.weblogic@epmlwas09a>
In-reply-to: <905389780.892831421050282747.JavaMail.weblogic@epmlwas09a>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsWyRsSkWFeqY3OIwaPJEhaP1yxmstg4Yz2r
	xaT7E1gsXr8wtOh//JrZ4mzTG3aLTY+vsVpc3jWHzeJz7xFGixnn9zFZLL1+kcniduMKNovH
	K96yW7TuPcJusWrXH0YHfo8189YweuycdZfdY/Gel0wem1Z1snlsXlLv0bdlFaPH501yAexR
	XDYpqTmZZalF+nYJXBmdu76wFCwVrdgz4SZzA+MiwS5GTg4JAROJe8e+MEHYYhIX7q1n62Lk
	4hASWMoo8afpMRtM0duT35ggEtMZJbYv/wTlvGaUWLRkGTtIFa+AhsT8ZxtYQGwWAVWJ609O
	M4LYbAJaEvtf3ACbJCoQJrFy+hUWiHpBiR+T74HZIgIyElc3bmcBGcos0Msm8W79ImaQhLBA
	qsSZGzvBFggJuEvsvncJ7FZOAQ+JTw//gjUzC6hLTJoHUc8sIC+xec1bZpBBEgIzOSQWdT1k
	grhIQOLb5ENADRxACVmJTQeYIV6TlDi44gbLBEaxWUhumoVk7CwkYxcwMq9iFE0tSC4oTkov
	MtUrTswtLs1L10vOz93ECIzt0/+eTdzBeP+A9SFGAQ5GJR5eC6nNIUKsiWXFlbmHGE2BrpjI
	LCWanA9MIHkl8YbGZkYWpiamxkbmlmZK4rw60j+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBK
	NTDyd032vLTT+Xh3e7HOjePP2B1/TrzSw/4618GG7WtI9ObzPFP+nlQo5Nqi98KhLvdTxb+V
	Z4/u4fqozB62yP5D45r8w/3iryemcVfO92Y9Y7J48abX160uNf5d6/QvwCU4UFBsV/S9u9Lr
	aydv/ejp65d4fp2cc17A3P7Koxe+3DvK1rHm4aUZSizFGYmGWsxFxYkA9ZrGIOgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jQV2pjs0hBhdW8Fk8XrOYyWLjjPWs
	FpPuT2CxeP3C0KL/8Wtmi7NNb9gtNj2+xmpxedccNovPvUcYLWac38dksfT6RSaL240r2Cwe
	r3jLbtG69wi7xapdfxgd+D3WzFvD6LFz1l12j8V7XjJ5bFrVyeaxeUm9R9+WVYwenzfJBbBH
	NTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDdraRQ
	lphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM6Nz1haVgqWjFngk3mRsYFwl2
	MXJySAiYSLw9+Y0JwhaTuHBvPVsXIxeHkMB0Rontyz8xQTivGSUWLVnGDlLFK6AhMf/ZBhYQ
	m0VAVeL6k9OMIDabgJbE/hc32EBsUYEwiZXTr7BA1AtK/Jh8D8wWEZCRuLpxOwvIUGaBXjaJ
	d+sXMYMkhAVSJc7c2Am2QEjAXWL3vUtgJ3EKeEh8evgXrJlZQF1i0jyIemYBeYnNa94yT2AU
	mIVkxywkZbOQlC1gZF7FKJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZw4nkntYFzZYHGIUYCD
	UYmH10Jqc4gQa2JZcWXuIUYJDmYlEV7XMqAQb0piZVVqUX58UWlOavEhRlNgEExklhJNzgcm
	tbySeENjEzMjSyNzQwsjY3MlcV4l+7YQIYH0xJLU7NTUgtQimD4mDk6pBsbM5XH7InyUIj6e
	nZUatV86Td+Ao+zli7mr1qqs45M6s/3tt6Nfn5jdsWY6l9RzTEY6J9zO57Xif4c9K0LmmXoe
	nfPHtU1148Xoz/N03klOXHiiQG57i6+00G3/0u0u7is5z0q5H3NL3rVwhaH1ztKXf3a4uh+W
	6Gs/U3PReJ9D9n7RvA+K7OZKLMUZiYZazEXFiQAvN11/MgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Myungjoo,

On 01/12/2015 05:11 PM, MyungJoo Ham wrote:
> 
> I have rephrased part of the documentation for better readability.
> Some semantics is guessed so you may need to re-rephrase.
> 
> Other than that, Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

OK, I'll fix them according to your below comment.

Best Regards,
Chanwoo Choi

> 
> 
>>  This patch adds the documentation for Exynos PPMU (Platform Performance
>> Monitoring Unit) devfreq-event driver.
>>
>> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>  .../bindings/devfreq/event/exynos-ppmu.txt         | 110 +++++++++++++++++++++
>>  1 file changed, 110 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
>>
>> diff --git a/Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt b/Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
>> new file mode 100644
>> index 0000000..e665d30
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
>> @@ -0,0 +1,110 @@
>> +
>> +* Samsung Exynos PPMU (Performance Profiling Monitoring Unit) device
>> +
>> +The Samsung Exynos SoC have PPMU (Performance Profiling Monitoring Unit) for
> 
> The Samsung Exynos SoC has PPMU (Performance Profiling Monitoring Unit) for
> (have->has)
> 
>> +each IPs. PPMU provides the primitive values to get performance data. These
> 
> each IP. PPMU provides primitive values to get performance data.
> (IPs->IP)
> 
>> +events provide useful information about the behavior of the SoC that you can
> 
> PPMU events provide information of the SoC's behaviors so that you may
> 
>> +use when analyzing system performance, and made visible and can be counted
> 
> use to analyze system performance, to make behaviors visible, and to count
> 
>> +using login in each IP (DMC, CPU, RIGHTBUS, LEFTBUS, CAM interface, LCD, G3D,
> 
> usages of each IP ( .... )
> 
>> +MFC). The Exynos PPMU driver use the devfreq-event class to provide event data
> 
> use -> uses
> 
>> +to various devfreq device. The devfreq device would use the event data when
> 
> device -> devices
> 
>> +derterming the current state of each IP.
>> +
>> +Required properties:
>> +- compatible: Should be "samsung,exynos-ppmu".
>> +- reg: physical base address of each PPMU and length of memory mapped region.
>> +
>> +Optional properties:
>> +- clock-names : the name of clock used by the PPMU, "ppmu"
>> +- clocks : phandles for clock specified in "clock-names" property
>> +- #clock-cells: should be 1.
>> +
> 
> []
> 

