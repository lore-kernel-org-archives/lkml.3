Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750932AbaLPEkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 23:40:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:36653 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaLPEkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 23:40:12 -0500
X-AuditID: cbfee68f-f791c6d000004834-a1-548fb7a8c9bc
Date: Tue, 16 Dec 2014 04:40:08 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: Re: Re: [3.18+] Can't boot with commit bd809af1
 ("x86: Enable PAT to use cache mode translation tables")
To: Juergen Gross <jgross@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20141216043601027@jongman.heo
Msgkey: 20141216043601027@jongman.heo
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141216043601027@jongman.heo
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <1194554367.45481418704807712.JavaMail.weblogic@epmlwas09d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWyRsSkQHfF9v4Qg9t3pCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGo/6bTAV3pCr29u9kbWBskOpi5OQQElCTuPn5ECOILSFgIrHo
	6RxmCFtM4sK99WwQNUsZJc68Euhi5ACreTtfuYuRCyg8h1HiftN8VpAaFgFViY4N38BsNgEd
	iY7/+8FsYYFCiYMPvzOC9IoIpEm0TreAGKkocW3pYrDxvAKCEidnPmGBWKsicafjBVRcVeLv
	kjOsEHEJiVnTL0DZvBIz2p9C1ctJTPu6BupkaYnzszYwwpy/+PtjqDi/xLHbO5ggbAGJqWcO
	QtVoSmyf9xpqJp/EmoVvWWDqd51azgyz6/6WuUwwN2xteQJWzwx0/5Tuh+wQtpbElx/7MPzC
	K+AucfTdZTZQWEkINHJIPO9byAYJKwGJb5MPsUxgVJyFpGcWkrmzkMxFVrOAkWUVo2hqQXJB
	cVJ6kbFecWJucWleul5yfu4mRmBaOP3vWf8OxrsHrA8xCnAwKvHwBhT2hwixJpYVV+YeYjQF
	Wj2RWUo0OR+YfPJK4g2NzYwsTE1MjY3MLc2UxHkXSv0MFhJITyxJzU5NLUgtii8qzUktPsTI
	xMEp1cBoVLXgfvzG0zEf1M7furT05+7JyZeWbFSMM5l/+NgcMbmDqw90TeQN06j2euH6P3vt
	GtHpLw+t+WTTlRfy+5Lk/Yw90re1L6/PzJi2ZPeukL47xcfDJCW/xMvGCnUHxTV4Lp/97sOM
	lGUetnM9/8swNp7xn7nrh6Rx8eH+Pea3Tiz/Iuh8VSlssRJLcUaioRZzUXEiAOitkWUGAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t/tXt0V2/tDDN6tF7a4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRmP
	+m8yFdyRqtjbv5O1gbFBqouRk0NIQE3i5udDjF2MHBwSAiYSb+crg4QlBMQkLtxbz9bFyAVU
	ModR4n7TfFaQBIuAqkTHhm9gNpuAjkTH//1gtrBAocTBh9/B5ogIpEm0TreAGK8ocW3pYjYQ
	m1dAUOLkzCcsEPNVJO50vICKq0r8XXKGFSIuITFr+gUom1diRvtTqHo5iWlf1zBD2NIS52dt
	YIS5c/H3x1Bxfoljt3cwQdgCElPPHISq0ZTYPu811Ew+iTUL37LA1O86tZwZZtf9LXOZYG7Y
	2vIErJ4Z6P4p3Q/ZIWwtiS8/9mH4hVfAXeLou8tsExhlZiFJzULSPgtJO7KaBYwsqxhFUwuS
	C4qT0iuM9IoTc4tL89L1kvNzNzGCk82zRTsY/523PsQowMGoxMMbWNgfIsSaWFZcmXuIUYKD
	WUmE130qUIg3JbGyKrUoP76oNCe1+BCjKTCiJjJLiSbnAxNhXkm8obGxiZmJqaWJhYGpuZI4
	7/9zuSFCAumJJanZqakFqUUwfUwcnFINjCH7TiUcO7CcbcLZR1NrODc2d9w4Fr63cX2E19Xq
	i9W9E/ccWK7w2FeyecWkPZPLJ99XWcdbyJN4bEPq14ojVzf827X1za29ITsyxBvkp4sznjue
	m/E4vZdl6o4TnosvPtyYvveRi+4ZG76D5wv595Z79Z6qjnW875L4VvVjbMNFf57y/BcZ7u+V
	WIozEg21mIuKEwHbs0w3TAMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBG4ehHv003962

>------- Original Message -------
>Sender : Juergen Gross<jgross@suse.com>
>Date : 2014-12-15 20:52 (GMT+09:00)
>Title : Re: [3.18+] Can't boot with commit bd809af1 ("x86: Enable PAT to use cache mode translation tables")
>
>On 12/15/2014 08:52 AM, Jongman Heo wrote:
>>> ------- Original Message -------
>>> Sender : Juergen Gross
>>> Date : 2014-12-15 14:04 (GMT+09:00)
>>> Title : Re: [3.18+] Can't boot with commit bd809af1 ("x86: Enable PAT to use cache mode translation tables")
>>>
>>> On 12/14/2014 06:07 AM, «„¡æ∏∏ wrote:
>>>>
>>>> Hi,
>>>>
>>>> My Linux virtual machine on (Windows) VMWare workstation 10 can't boot with following commit.
>>>>
>>>> commit bd809af16e3ab1f8d55b3e2928c47c67e2a865d2
>>>> Author: Juergen Gross
>>>> Date:   Mon Nov 3 14:02:03 2014 +0100
>>>>
>>>>       x86: Enable PAT to use cache mode translation tables
>>>>
>>>> Unfortunately I can't see any console log.
>>>
>>> Hmm, weird. Could you provide some more information?
>>>
>>> Kernel config, hardware used, /proc/cpuinfo of working kernel?
>>> Anything you see with earlyprintk enabled?
>>>
>>>
>>> Juergen
>> 
>> (Sorry for resending this email, previous one bounced from mailing list due to HTML format)
>> 
>> Hi,
>> 
>> I'm using Fedora 21, with custom built kernel.
>> Host PC is windows 7 64-bit, and running VMWare workstation 10 for guest Fedora Linux.
>> 
>> With earlyprintk, just following message is printed.
>> 
>>    early console in setup code
>> 
>> and nothing more...
> 
> Can you try attached diagnostic patch, please? I suspect a problem
> regarding VMWares PAT emulation...
> 
> 
> Juergen

Hi, 

With the commit reverted, the patch doesn't apply.
Without revert, kernel (patch applied) doesn't boot and I can't see any message.

Let me show you my PAT values (the commit reverted)

# dmesg | grep PAT
[    0.000000] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
[    0.314631] x86 PAT enabled: cpu 3, old 0x0, new 0x7010600070106
[    0.314703] x86 PAT enabled: cpu 1, old 0x0, new 0x7010600070106
[    0.314780] x86 PAT enabled: cpu 2, old 0x0, new 0x7010600070106
[    0.314852] x86 PAT enabled: cpu 4, old 0x0, new 0x7010600070106
[    0.314923] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
[    0.314997] x86 PAT enabled: cpu 6, old 0x0, new 0x7010600070106
[    0.315069] x86 PAT enabled: cpu 7, old 0x0, new 0x7010600070106
[    0.315142] x86 PAT enabled: cpu 5, old 0x0, new 0x7010600070106
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
