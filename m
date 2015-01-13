Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbbAMJE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:04:56 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:21617 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbbAMJEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:04:53 -0500
X-AuditID: cbfee691-f79b86d000004a5a-30-54b4df9f33a0
Date: Tue, 13 Jan 2015 09:04:31 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCHv3 2/8] devfreq: exynos: Add documentation for generic
 exynos memory bus frequency driver
To: =?utf-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>,
        Rob Herring <robherring2@gmail.com>
Cc: "kgene@kernel.org" <kgene@kernel.org>,
        =?utf-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        =?utf-8?Q?=EB=8C=80=EC=9D=B8=EA=B8=B0?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20150113085513826@myungjoo.ham
Msgkey: 20150113085513826@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150113085513826@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <1866237785.970311421139868224.JavaMail.weblogic@epmlwas05d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsWyRsSkUHfB/S0hBj/cLC7vmsPmwOjxeZNc
	AGMUl01Kak5mWWqRvl0CV8bEa8vZC64JVty8UdXAOEOwi5GTQ0hAXWLRkpNsILaEgInEmd0r
	2SFsMYkL99azQdQsZZSY9x/I5gCr2Tc9r4uRCyg8h1Hi151tYPUsAqoSNxbfZwSpYRPQk5j5
	ORkkLCxQING/7zITiC0ikCcx98oeNpBeZoH9bBIznh9jgZivJLFm3yswm1dAUOLkzCcsEDeo
	Siye3QIVV5OYPGkfI0RcXOLC3EtQd/JKzGh/ClUvJzHt6xpmCFta4vysDYwwvyz+/hgqzi9x
	7PYOJghbQGLqmYNQNVoSj5auhZrDJ7Fm4VsWmPpdp5Yzw+y6v2UuVK+ExNaWJ6wgNrOAosSU
	7ofsIL8zC2hKrN+lj+4VXgEPie0H5jOC/C4hMJVD4uW23SwTGJVmIambhWTULIRRyEoWMLKs
	YhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAhMCKf/PZu4g/H+AetDjAIcjEo8vDuyt4QIsSaW
	FVfmHmI0BcbSRGYp0eR8YNrJK4k3NDYzsjA1MTU2Mrc0UxLn1ZH+GSwkkJ5YkpqdmlqQWhRf
	VJqTWnyIkYmDU6qBsSEsQnfjMpPLvkaXc59KPLVad36jJdeWI6sZ72e6rbhl/HK+3knPsoop
	C4uvvtatZHr+++GTOPODxp43c1xCzsw/4MdX8XDCb69JWTH75r89Gf/bpcuFbab8FG/NzQ6W
	nPe8nP/nqTxMKF2p3MMisW9F166//68HrGr5eC0k+98cpVdRF6t+3lZiKc5INNRiLipOBACg
	Z2KiAwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t/tXt3597eEGMw9ZGFxedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DI1jrQwNDIxMgWoS0jIm
	XlvOXnBNsOLmjaoGxhmCXYycHEIC6hKLlpxk62Lk4JAQMJHYNz0PJCwhICZx4d56oDAXUMkc
	Rolfd7axgyRYBFQlbiy+zwhSzyagJzHzczJIWFigQKJ/32UmEFtEIE9i7pU9YL3MAvvZJGY8
	P8YCsUtJYs2+V2A2r4CgxMmZT1gglqlKLJ7dAhVXk5g8aR8jRFxc4sLcS+wQNq/EjPanUPVy
	EtO+rmGGsKUlzs/awAhz9OLvj6Hi/BLHbu9ggrAFJKaeOQhVoyXxaOlaqDl8EmsWvmWBqd91
	ajkzzK77W+ZC9UpIbG15wgpiMwsoSkzpfsgO8juzgKbE+l366F7hFfCQ2H5gPuMERtlZSFKz
	kHTPQuhGVrKAkWUVo2hqQXJBcVJ6hZFecWJucWleul5yfu4mRnACerZoB+O/89aHGAU4GJV4
	eHdkbwkRYk0sK67MPcQowcGsJMI7/zZQiDclsbIqtSg/vqg0J7X4EKMpMM4mMkuJJucDk2Ne
	SbyhsbGJmYmppYmFgam5kjjv/3O5IUIC6YklqdmpqQWpRTB9TBycUg2MLjHMhr63ogImp6/b
	sf+SU7P2/pCVAn/2uLIcm2jNv+j0xQv+8yR8N9hL3q9Z03lqssHEeVKX/UK/dvXX/BbuY+v6
	pT/5qUys0ZGNhvGTGh54tJUcKWg4vD5m3uLvNqpS+YxtL1cc+OOYn3WN0e2lyUQVnWZX2W/r
	Lc48PHrQIX3Tr+y3hsyzlViKMxINtZiLihMB6qeF5lYDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0D952xh026373


Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>


Adding to Chanwoo's reply:

If I understand Chanwoo's intention correctly,
this patchset is to provide a common bus & memory-interface DVFS driver
for several Exynos SoCs, which allows DT to express per-SoC hardware
details so that we do not need to hardcode them with seperated drivers
(as it is now) or a driver with a lot of unused definitions (partly
as it is now).

Having that many looking ugly frequency definitions is
because Exynos SoCs that I've seen until today have many
on-SoC IPs that should change configurations (usually clock speed)
according to the clock speed of bus. Thus, they may look
duplicated.

We may hide such details IF we make one driver per SoC model; however,
it is very inefficient with DT supported kernels if we can write
such details in DTS and make the driver simple and unified.



Cheers,
MyungJoo.

>  
> Hi Rob,
>
>First of all, thanks for your review.
>
>On 01/09/2015 06:18 AM, Rob Herring wrote:
>> Adding Viresh.
>> 
>> On Wed, Jan 7, 2015 at 7:40 PM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>> This patch adds the documentation for generic exynos memory bus frequency
>>> driver.
>>>
>>> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
>>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>>> Cc: Kukjin Kim <kgene@kernel.org>
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> ---
>>>  .../devicetree/bindings/devfreq/exynos-busfreq.txt | 184 +++++++++++++++++++++
>>>  1 file changed, 184 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/devfreq/exynos-busfreq.txt
>>>
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
