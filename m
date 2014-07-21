Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaGUBmx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 21:42:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45032 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaGUBmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 21:42:51 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-1c-53cc70124b49
Date: Mon, 21 Jul 2014 01:42:42 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v4] PM / devfreq: Add possible_frequencies device attribute
To: Saravana Kannan <skannan@codeaurora.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140721014009184@myungjoo.ham
Msgkey: 20140721014009184@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140721014009184@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <2979470.179111405906960960.JavaMail.weblogic@epml01>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42JZI2JSpCtUcCbYYMp/PovLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJVxeeYj1oI/XBX3pp5nbWC8wtXFyMkhJKAusWjJSTYQW0LARGJa
	71pWCFtM4sK99UBxLqCapYwS167MY4cpen7iFAtEYg6jxOZ9s8C6WQRUJb5MOwBUxMHBJmAu
	cX9GEEhYWMBf4s3KvywgtohAvkTvzptMIL3MAn1MEivnP2KDuEJJYs2+V2BFvAKCEidnPmGB
	WKYqceXCdSaIuJrEv5lroK6TkJg1/QKUzSsxo/0pVL2cxLSva5ghbGmJ87M2MMJ8s/j7Y6g4
	v8Sx2zuYQO4E6X1yPxhmzO7NX6ABISAx9cxBqFYtiektB6BW8UmsWfiWBWbMrlPLmWF672+Z
	C3Yms4CixJTuh+wQtpbElx/72NC9xSvgKPH/9WmmCYzKs5CkZiFpn4WkHVnNAkaWVYyiqQXJ
	BcVJ6UWGesWJucWleel6yfm5mxiBieH0v2e9OxhvH7A+xJgMjJKJzFKiyfnAxJJXEm9obGZk
	YWpiamxkbmlGmrCSOG/Sw6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwlHStLQ9cxnbAX
	uu7sbzVlccPLyxtnq/Vu3VyZ/Iw5be6M6fs8FBWtfkffMwvrlV23P3AVE/PxdeePmMdsPTQt
	qO6aUOjUwij1HwYzHWumH/6zg+fwATPW/t396py26Quj8rgneb79JrN6o/ntcJWUGOmPb9k/
	v/tts/BUzM6I9K9RfxyiZC4rsRRnJBpqMRcVJwIAwFZ0byIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e92n65QwZlgg1U/2C0u75rD5sDo8XmT
	XABjVJpNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrShuZGekYGeqZGeoXGslaGBgZEpUE1CWsbl
	mY9YC/5wVdybep61gfEKVxcjJ4eQgLrEoiUn2UBsCQETiecnTrFA2GISF+6tB4pzAdXMYZTY
	vG8WWBGLgKrEl2kH2LsYOTjYBMwl7s8IAgkLC/hLvFn5F6xXRCBfonfnTSaQXmaBPiaJlfMf
	sUEsU5JYs+8VWBGvgKDEyZlPoJapSly5cJ0JIq4m8W/mGlaIuITErOkXoGxeiRntT6Hq5SSm
	fV3DDGFLS5yftYER5ujF3x9Dxfkljt3ewQRyJ0jvk/vBMGN2b/4C9a+AxNQzB6FatSSmtxyA
	WsUnsWbhWxaYMbtOLWeG6b2/ZS7YmcwCihJTuh+yQ9haEl9+7GND9xavgKPE/9enmSYwys1C
	kpqFpH0WknZkNQsYWVYxiqYWJBcUJ6VXGOkVJ+YWl+al6yXn525iBKenZ4t2MP47b32IUYCD
	UYmHdwHzmWAh1sSy4srcQ4wSHMxKIrwnMoBCvCmJlVWpRfnxRaU5qcWHGJOBETiRWUo0OR+Y
	OvNK4g2NjU3MTEwtTSwMTM1JE1YS55W/lRQkJJCeWJKanZpakFoEs4WJg1OqgfHGqQtspzqN
	al72eE4yOarj4LshvXy/3Y89927OiXu53boo6sq/usQD75YfO5r5517LtHebTtycsfZK3YWF
	ttXSoYLL/8q/UxCYeeV+/IPMYC+V3rC7u/vOVvTvSnU5M+3AZOVzRkZb69vUpkyp1X1Zx8/W
	G3kmcsPVmELXDb7py98su7UuZPM7JZbijERDLeai4kQATnGmLZMDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6L1gw4S026664

Sender : Saravana Kannan<skannan@codeaurora.org>
Title : [PATCH v4] PM / devfreq: Add possible_frequencies device attribute
>
> Some devices use freq_table instead of OPP. For those devices, the
> available_frequencies sysfs file shows up empty. So, add a
> possible_frequencies attribute/syfs file that list all the possible
> frequencies.
>
> For devices that use OPP, the output of this file will match
> available_frequencies. It may change in the future to show all OPP
> frequencies -- even the disabled ones.
>
> Signed-off-by: Saravana Kannan 

Looks Good.
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>

I'll rebase and merge into devfreq-next when I get back (I can only access the Internet via mobile phones until Wed this week.)
I'll move this sysfs entry to .../stat along with stat sysfs and make it conditional (appears only when stat is available)

Cheers,
MyungJoo.
--
MyungJoo Ham («‘∏Ì¡÷), PHD
Frontier CS Lab, Software Center
Samsung Electronics
Cell: +82-10-6714-2858ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
