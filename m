Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab3JJEHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 00:07:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43765 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3JJEHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 00:07:53 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-c3-52562818b784
Message-id: <5256281C.8040706@samsung.com>
Date: Thu, 10 Oct 2013 13:07:56 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, ijc+devicetree@hellion.org.uk,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 3/3] ARM: dts: exynos4x12: Add maudio/gps_alive power
 domain for exynos4x12
References: <1381365007-1782-1-git-send-email-cw00.choi@samsung.com>
 <1381365007-1782-4-git-send-email-cw00.choi@samsung.com>
 <CAK9yfHxr27nsmaqkE+seDgZAkpUmOsPqdXdeogY89tAXYEEG2w@mail.gmail.com>
 <525627A2.70709@samsung.com>
In-reply-to: <525627A2.70709@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWyRsSkUFdCIyzI4OcBTov5R86xWpx7tZLR
	onfBVTaLs01v2C02Pb7GanF51xw2ixnn9zFZ3L7Ma7H0+kUmiwnT17JYHF5xgMni5J9eRotX
	B9tYLNbPeM3iwOexZt4aRo+W5h42jwWfr7B7rFz+hc3jzrU9bB6bl9R79G1ZxejxeZOcx8a5
	oQGcUVw2Kak5mWWpRfp2CVwZu59vZylYwVOx+0EnewPjA84uRk4OCQETib3ft7NC2GISF+6t
	Z+ti5OIQEljKKPF05nsWmKKpE/qZIRLTGSWO71rBCOG8YpT4tfEyM0gVr4CWxMWfn8FGsQio
	Smya85QdxGYDiu9/cYMNxBYVCJNYOf0KC0S9oMSPyffAbBGgmpfdy5lAhjIL9LJInDl7AmyQ
	sECixIo/h1ghtj1llLjUdhYswSmgKXFoxnOwzcwCOhL7W6exQdjyEpvXvAW7VUJgJodE89M/
	UCcJSHybfAhoHQdQQlZi0wFmiN8kJQ6uuMEygVFsFpKjZiEZOwvJ2AWMzKsYRVMLkguKk9KL
	TPWKE3OLS/PS9ZLzczcxAqP89L9nE3cw3j9gfYgxGWjlRGYp0eR8YJLIK4k3NDYzsjA1MTU2
	Mrc0I01YSZxXvcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOjYCbLcdbWVRyp85Y8mX4s
	x3Wjf9w5r+vL70yX+qEcmZL60yPPZdmKaW9dN2U2XFZ9m5a85UxJ1ue118pCOL9Oe8UuVfuM
	78S02ybi+68rJf5Q63Zs+fptw8uwSL9z1SHflUt++i+Yovqte1aLSmt0rdu6fLdDgrVGLtcr
	TqktmvZVmsHpu2+sEktxRqKhFnNRcSIAzvhYYggDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsVy+t9jQV0JjbAgg3Ydi/lHzrFanHu1ktGi
	d8FVNouzTW/YLTY9vsZqcXnXHDaLGef3MVncvsxrsfT6RSaLCdPXslgcXnGAyeLkn15Gi1cH
	21gs1s94zeLA57Fm3hpGj5bmHjaPBZ+vsHusXP6FzePOtT1sHpuX1Hv0bVnF6PF5k5zHxrmh
	AZxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCn
	KymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzdj/fzlKwgqdi94NO9gbG
	B5xdjJwcEgImElMn9DND2GISF+6tZ+ti5OIQEpjOKHF81wpGCOcVo8SvjZfBqngFtCQu/vzM
	CmKzCKhKbJrzlB3EZgOK739xgw3EFhUIk1g5/QoLRL2gxI/J98BsEaCal93LmUCGMgv0skic
	OXsCbJCwQKLEij+HWCG2PWWUuNR2FizBKaApcWjGc7DNzAI6Evtbp7FB2PISm9e8ZZ7AKDAL
	yZJZSMpmISlbwMi8ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4gTyT2sG4ssHiEKMAB6MS
	D29FWWiQEGtiWXFl7iFGCQ5mJRHe6SeBQrwpiZVVqUX58UWlOanFhxiTgWEwkVlKNDkfmNzy
	SuINjU3MjCyNzA0tjIzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoExO2tn2wyFqN99
	jR2TNBoifGew3XSxS1sv9drSP2jzJ57S+b3c7xeaT9hysbNk/0L5a8b1R/xOGP84tEfgWnTh
	yhbug63vOIJ0VKXrfvpuSO5cYz//W/Afdq3OmNu35ky5J6PfcVPmQYZmtmul+dNkG2/791O+
	Z39weufKfnHOH577hyoSfworsRRnJBpqMRcVJwIAzMh/h2QDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 01:05 PM, Chanwoo Choi wrote:
> On 10/10/2013 12:29 PM, Sachin Kamat wrote:
>> On 10 October 2013 06:00, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>> This patch maudio/gps_alive power domain to exynos4x12.dtsi.
>>>
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>>  arch/arm/boot/dts/exynos4x12.dtsi | 10 ++++++++++
>>>  1 file changed, 10 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
>>> index ad531fe..c04418e 100644
>>> --- a/arch/arm/boot/dts/exynos4x12.dtsi
>>> +++ b/arch/arm/boot/dts/exynos4x12.dtsi
>>> @@ -35,6 +35,16 @@
>>>                 reg = <0x10023CA0 0x20>;
>>>         };
>>>
>>> +       pd_maudio: maudio-power-domain@10023CC0 {
>>> +               compatible = "samsung,exynos4210-pd";
>>> +               reg = <0x10023CC0 0x20>;
>>> +       };
>>> +
>>> +       pd_gps_alive: gps-alive-power-domain@10023D04 {
>>> +               compatible = "samsung,exynos4210-pd";
>>> +               reg = <0x10023D00 0x20>;
>>
>> There is mismatch between node name and register value.
>>
>>
> What is exactly mismatch?
> 
> I checked the register address of MAUDIO_CONFIGURATION/GPS_ALIVE_CONFIGURATION regsiter.
> - MAUDIO_CONFIGURATION 0x1002_3CC0
> - GPS_ALIVE_CONFIGURATION 0x1002_3D00

My mistake. I write wrong address about gps-alive-power-domain.

I will fix it.
- gps-alive-power-domain@10023D04 -> gps-alive-power-domain@10023D00

Thanks,
Chanwoo Choi

