Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaDRKrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 06:47:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12965 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaDRKrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 06:47:18 -0400
X-AuditID: cbfee68f-b7f156d00000276c-90-535102b499a0
Date: Fri, 18 Apr 2014 10:47:16 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH] PM / devfreq: Use freq_table for available_frequencies
To: Saravana Kannan <skannan@codeaurora.org>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140418104206866@myungjoo.ham
Msgkey: 20140418104206866@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140418104206866@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <13080425.28271397818035336.JavaMail.weblogic@epv6ml12>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42JZI2JSrLuFKTDY4FmLqsXlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4Mponr6aueAER8W1eYeZGhhXcHQxcnIICahLLFpykg3ElhAwkXg0
	4QQThC0mceHeejaImqWMEnO22MDUtE5eztjFyAUUn88osffffWaQBIuAqsTttXPYuxg5ONgE
	9CRmfk4GCQsL+Esc7T/MDmKLAIWPNK1gBellFjjPJHGx6xQTxAIliTX7XrGA2LwCghInZz5h
	gVimKnH2xmOouJrE4vU/oQ6VkJg1/QIrhM0rMaP9KVS9nMS0r2uYIWxpifOzNjDCPLP4+2Oo
	OL/Esds7mEDuBOl9cj8YZszuzV+gxgtITD1zEKpVS2Lzz4lQNp/EmoVvWWDG7Dq1nBmm9/6W
	uWCvMAsoSkzpfsgOYWtJfPmxjw3dW7wCzhK979ewTWBUnoUkNQtJ+ywk7chqFjCyrGIUTS1I
	LihOSi8y1itOzC0uzUvXS87P3cQITAun/z3r38F494D1IcZkYJRMZJYSTc4HppW8knhDYzMj
	C1MTU2Mjc0sz0oSVxHnvP0wKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cC4Vunt6f8PX/Dl
	JPn0aO6auuTtD82JUQwZNZsqX/25qH0l4ZuD/Oo3va1OxVvl5r25W9OeOVGpjHX1nrtMLr06
	LGZsnj+2zlma2XxmAePiw15X+l3fLZ9oL2ugun3dWTcTz/SArA7uF5tfRu3uemYp7PlQIP1N
	QfLu7/7L3Kbas/OmMpSoROxVYinOSDTUYi4qTgQABW00xyEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2dN0tTIHBBv8vyllc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIzm
	6auZC05wVFybd5ipgXEFRxcjJ4eQgLrEoiUn2UBsCQETidbJyxkhbDGJC/fWA8W5gGrmM0rs
	/XefGSTBIqAqcXvtHPYuRg4ONgE9iZmfk0HCwgL+Ekf7D7OD2CJA4SNNK1hBepkFzjNJXOw6
	xQSxTElizb5XLCA2r4CgxMmZT1gglqlKnL3xGCquJrF4/U+ogyQkZk2/wAph80rMaH8KVS8n
	Me3rGmYIW1ri/KwNcEcv/v4YKs4vcez2DiaQO0F6n9wPhhmze/MXqPECElPPHIRq1ZLY/HMi
	lM0nsWbhWxaYMbtOLWeG6b2/ZS7YK8wCihJTuh+yQ9haEl9+7GND9xavgLNE7/s1bBMY5WYh
	Sc1C0j4LSTuymgWMLKsYRVMLkguKk9IrDPWKE3OLS/PS9ZLzczcxgtPTs4U7GL+ctz7EKMDB
	qMTDe+Grf7AQa2JZcWXuIUYJDmYlEd7dfwOChXhTEiurUovy44tKc1KLDzEmAyNwIrOUaHI+
	MHXmlcQbGhubmJmYWppYGJiakyasJM5792ZSkJBAemJJanZqakFqEcwWJg5OqQbG/sCZl+32
	bFyS8WvuvR3OFz65V7W5qXx/q/GLRdVa1MF4yRSJnyynA4QeBEe+8HpUxN/84XxRvKDnjXPq
	z/avibI5bqVhf+Z4wEcxnrUTDtk7VcWcsw1928F7Winmfs2Vic/8HvTaGrCE7Yz3aQ1O3u3M
	8DDJrjL1zqfH71cvqH6x8/Ta8/1HlFiKMxINtZiLihMB3b2WMZMDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3IAmDmG019915

> On 04/15/2014 11:41 AM, Saravana Kannan wrote:
> > Ah, I misunderstood your previous email. I thought you Nack-ed my patch
> > and decided to send your own patch to replace mine. Ok, I'll fix up mine
> > and send it out.
> 
> MyungJoo/Kyungmin,
> 
> I sent out an updated patch. Can you please take a look?
> 
> Thanks,
> Saravana

I'll be away from most of network system during the weekend.
And I'll be only accessing mobile phones (no laptops or desktops) until next Wednesday.

Please let me look at this a while later. (I'll have other pending tons of messages as well at that time)

Sorry for the extended delay.

Cheers,
MyungJoo.

> 
> 
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
