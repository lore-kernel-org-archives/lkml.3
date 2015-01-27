Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbbA0J72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 04:59:28 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:21491 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbbA0J7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 04:59:24 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-d3-54c76179c339
Date: Tue, 27 Jan 2015 09:59:21 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v10 0/7] devfreq: Add devfreq-event class to provide raw
 data for devfreq device
To: =?utf-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>,
        "kgene@kernel.org" <kgene@kernel.org>
Cc: =?utf-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?utf-8?Q?=EC=9D=B4=EC=83=81=EB=B0=B0?= <sangbae90.lee@samsung.com>,
        =?utf-8?Q?=EB=8C=80=EC=9D=B8=EA=B8=B0?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20150127095704556@myungjoo.ham
Msgkey: 20150127095704556@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150127095704556@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <2091672023.141961422352757659.JavaMail.weblogic@epmlwas08c>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWyRsSkULcy8XiIweo9PBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStj+YKDrAWvOCu62l4xNTAe4exi5OQQElCXWLTkJBuILSFgInHg
	7ENmCFtM4sK99WwQNUsZJWbeyIKp+Xa5AaiGCyg+h1FizewusAYWAVWJVWc7mLoYOTjYBPQk
	Zn5OBgkLC6RIvJ+3iB3EFhHIk7hydwYjSC+zwFU2iaXPVzFDLFCSWLPvFQuIzSsgKHFy5hMW
	iGWqEtP/zGeDiKtJ7Jz5jxEiLi5xYe4ldgibV2JG+1OoejmJaV/XQD0gLXF+1gZGmGcWf38M
	FeeXOHZ7BxOELSAx9cxBqBotiQOXtkLZfBJrFr5lganfdWo5M8yu+1vmQvVKSGxtecIKYjML
	KEpM6X7IDvI7s4CmxPpd+uhe4RXwkHjWMQ8cbhICUzkkfj5ewjSBUWkWkrpZSEbNQhiFrGQB
	I8sqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjMC0cPrfswk7GO8dsD7EKMDBqMTDu+HmsRAh
	1sSy4srcQ4ymwFiayCwlmpwPTD55JfGGxmZGFqYmpsZG5pZmSuK8r6V+BgsJpCeWpGanphak
	FsUXleakFh9iZOLglGpgXLXxhu+/S5J3X7wQ6j/5+eGJ8K0iB4oOcWpqXXMy4U/lOGn85jn7
	Lss7179I/Z4Ul/VMxMrnkbGuYd9zhdsZWrsOlq3TnJwh9Xv7sSeHsie/VFt0KSBySXR61+q4
	SalCkmGnd1VZ5iT9f10hszDna7bglOM9a29NvFD8snX/r79v10Yfr+neFaHEUpyRaKjFXFSc
	CACeSbTBBgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t/tXt3KxOMhBjd6WC0u75rD5sDo8XmT
	XABjVJpNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrShuZGekYGeqZGeoXGslaGBgZEpUE1CWsby
	BQdZC15xVnS1vWJqYDzC2cXIySEkoC6xaMlJNhBbQsBE4tvlBmYIW0ziwr31QHEuoJo5jBJr
	ZneBJVgEVCVWne1g6mLk4GAT0JOY+TkZJCwskCLxft4idhBbRCBP4srdGYwgvcwCV9kklj5f
	xQyxTElizb5XLCA2r4CgxMmZT1gglqlKTP8znw0iriaxc+Y/Roi4uMSFuZfYIWxeiRntT6Hq
	5SSmfV0Ddai0xPlZGxhhjl78/TFUnF/i2O0dTBC2gMTUMweharQkDlzaCmXzSaxZ+JYFpn7X
	qeXMMLvub5kL1SshsbXlCSuIzSygKDGl+yE7yO/MApoS63fpo3uFV8BD4lnHPOYJjLKzkKRm
	IemehdCNrGQBI8sqRtHUguSC4qT0CkO94sTc4tK8dL3k/NxNjOAk9GzhDsYv560PMQpwMCrx
	8EZePxYixJpYVlyZe4hRgoNZSYTXK+J4iBBvSmJlVWpRfnxRaU5q8SFGU2CcTWSWEk3OBybI
	vJJ4Q2NjEzMTU0sTCwNTcyVx3v/nckOEBNITS1KzU1MLUotg+pg4OKUaGL0XpR6Z/U5rdenD
	zqzIkqbHuY87tttOyTxScj/tn4/CvdMCO175m9967G60a8dC7aaOx3zNz1SOfd3esrRzk2Kh
	dIHo1vKGz/3f1V7f8AwO9ldPT3x0t8u9LnviUqsdEV/0Ek+tDuILnCubuqOPbcohnY+1RjN3
	n48uFHbcp/L5TYh9gtXMFiWW4oxEQy3mouJEADxyS3JYAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0R9xaxh024104

>  This patchset add new devfreq_event class to provide raw data to determine
> current utilization of device  which is used for devfreq governor.
> 
> The following description explains the feature of two kind of devfreq class:
> - devfreq class (existing)
>  : devfreq consumer device use raw data from devfreq_event device for
>    determining proper current system state and change voltage/frequency
>    dynamically using various governors.
> - devfreq_event class (new)
>  : Provide measured raw data to devfreq device for governor

Merged in my local git repo (1/7 to 3/7 as those three are in /drivers/devfreq).

However, the admin requires me to setup the firewall again, so please wait
another day for the merged patches to show up in external network
(git.kernel.org) and to make a pull-request for Rafael.
(waiting firewall execption approvals from the admin)


Cheers,
MyungJoo

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
