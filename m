Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbbAMJHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:07:36 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:15544 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbAMJH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:07:29 -0500
X-AuditID: cbfee68f-f791c6d000004834-f9-54b4e04976e5
Date: Tue, 13 Jan 2015 09:07:21 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCHv3 1/8] devfreq: exynos: Add generic exynos memory bus
 frequency driver
To: =?utf-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>
Cc: "kgene@kernel.org" <kgene@kernel.org>,
        =?utf-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?utf-8?Q?=EB=8C=80=EC=9D=B8=EA=B8=B0?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20150113090441450@myungjoo.ham
Msgkey: 20150113090441450@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150113090441450@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <2009992739.970611421140038667.JavaMail.weblogic@epmlwas05d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWyRsSkRNfzwZYQg8W7LCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGxfUN7AWPZCv+//zH3MD4R6aLkZNDSEBdYtGSk2wgtoSAicTW
	nfehbDGJC/fWA9lcQDVLGSXebn3MDFP0/PAxJojEHEaJl7/XgiVYBFQl3h+7CtTBwcEmoCcx
	83MyiCksECfx+pIQSIWIgKvEyrWLWEBamQW2skkc+rKZDeIIJYk1+16xgNi8AoISJ2c+YYHY
	pSpx/9MVRoi4msTdnwegjhOXuDD3EjuEzSsxo/0pVL2cxLSva6DulJY4P2sDI8wzi7/D3M8v
	cez2DiYIW0Bi6pmDUDVaEn9n74WaySexZuFbFpj6XaeWM8Psur9lLlSvhMTWliesIDazgKLE
	lO6H7CD/MgtoSqzfpY/uFV4BD4nmlk5wsEkITOWQ6P36g2kCo9IsJHWzkIyahTAKWckCRpZV
	jKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGIFp4fS/Z/07GO8esD7EKMDBqMTDuyN7S4gQa2JZ
	cWXuIUZTYCRNZJYSTc4HJp+8knhDYzMjC1MTU2Mjc0szJXHehVI/g4UE0hNLUrNTUwtSi+KL
	SnNSiw8xMnFwSjUwLjb6/8dWaF6mckjjD68rwtNb307858PvkH8n8uT5/m0qS/6H1KvzZEmJ
	LCqb+yaivvL4euer3rphNQXJtyZlNC026RCcmye4tlnyj37oDzGWHKkdq1MUeq6Irpkw0/ye
	XsC+De1TmeomNc6umv7XIPVXwt1Lapuyjl2+uNZCyLxwqkg7k3KfEktxRqKhFnNRcSIASBYB
	jwYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t/tXl3PB1tCDL7+M7C4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRkX
	1zewFzySrfj/8x9zA+MfmS5GTg4hAXWJRUtOsoHYEgImEs8PH2OCsMUkLtxbDxTnAqqZwyjx
	8vdaZpAEi4CqxPtjV4ESHBxsAnoSMz8ng5jCAnESry8JgVSICLhKrFy7iAWklVlgK5vEoS+b
	2SB2KUms2feKBcTmFRCUODnzCQvELlWJ+5+uMELE1STu/jwAdY+4xIW5l9ghbF6JGe1Poerl
	JKZ9XcMMYUtLnJ+1gRHm5sXfH0PF+SWO3d4B9YuAxNQzB6FqtCT+zt4LNZNPYs3Ctyww9btO
	LWeG2XV/y1yoXgmJrS1PWEFsZgFFiSndD9lB/mUW0JRYv0sf3Su8Ah4SzS2dTBMYZWchSc1C
	0j0LoRtZyQJGllWMoqkFyQXFSekVhnrFibnFpXnpesn5uZsYwSno2cIdjF/OWx9iFOBgVOLh
	3ZG9JUSINbGsuDL3EKMEB7OSCO/820Ah3pTEyqrUovz4otKc1OJDjKbAKJvILCWanA9Mj3kl
	8YbGxiZmJqaWJhYGpuZK4rz/z+WGCAmkJ5akZqemFqQWwfQxcXBKNTBunq75z+74/ov/BPZw
	r7gk0sSz2dV+4rzCtW0WS3PYan3mxkmlPbnrWrzE9pRoSfx65Zb3C3LMP362uXEj+M1b7ZnJ
	yft5w/4l3uJft639fmSQtv1qZbMasx3s1TOeTlS5sd7RXDx6wdsF8lO6znx03bbrlVbWsuBu
	50sic+edqBTcf6rj3KEkJZbijERDLeai4kQAT6/QUlcDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0D97gVD026394

>  
> Dear Myungjoo,
>
>On 01/13/2015 05:42 PM, MyungJoo Ham wrote:
>>>   
>>>  This patch adds the generic exynos bus frequency driver for memory bus
>>> with DEVFREQ framework. The Samsung Exynos SoCs have the common architecture
>>> for memory bus between DRAM memory and MMC/sub IP in SoC. This driver can
>>> support the memory bus frequency driver for Exynos SoCs.
>>>
>>> Each memory bus block has a clock for memory bus speed and frequency
>>> table which is changed according to the utilization of memory bus on runtime.
>>> And then each memory bus group has the one more memory bus blocks and
>>> OPP table (including frequency and voltage), regulator, devfreq-event
>>> devices.
>>>
>>> There are a little difference about the number of memory bus because each Exynos
>>> SoC have the different sub-IP and different memory bus speed. In spite of this
>>> difference among Exynos SoCs, we can support almost Exynos SoC by adding
>>> unique data of memory bus to devicetree file.
>>>
>>> Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
>>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>>> Cc: Kukjin Kim <kgene@kernel.org>
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> ---
>>>  drivers/devfreq/Kconfig          |  15 +
>>>  drivers/devfreq/Makefile         |   1 +
>>>  drivers/devfreq/exynos-busfreq.c | 589 +++++++++++++++++++++++++++++++++++++++
>>>  3 files changed, 605 insertions(+)
>>>  create mode 100644 drivers/devfreq/exynos-busfreq.c
>> 
>> Exynos drivers are located at drivers/devfreq/exynos/
>> Please relocate/rename exynos-busfreq.c
>
>OK. I'll move it at drivers/devfreq/exynos directory.
>Do you prefer 'exynos-bus.c' instead of 'exynos-busfreq.c'?
>If you reply, I'll change it.

exynos-bus looks more pretty :)

>
>> 
>> []
>> 
>>> diff --git a/drivers/devfreq/exynos-busfreq.c b/drivers/devfreq/exynos-busfreq.c
>>> new file mode 100644
>>> index 0000000..b180f43
>>> --- /dev/null
>>> +++ b/drivers/devfreq/exynos-busfreq.c
>> 
>> []
>> 
>>> +
>>> +#define BUS_SATURATION_RATIO	40
>> 
>> In order to be a common driver, this should be tunable.
>> 
>> Because .dts is supposed to have hardware configuration only,
>> you may keep a table of { chip-name, saturation ratio} in this
>> driver and look up the saturation ratio based on the chip-name.
>
>OK, I'll add new property for saturation_ratio.
>
>I'll implement to use default saturation_ratio value ,
>if dt node don't include saturation_ratio property.

Yes. I didn't talk with DT maintainers and I do not have much
experience with DT; however, it appears that such values are not
recommended to be in DTS files and this value is determined by
the SoC model number without complications in the driver file.

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
