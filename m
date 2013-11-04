Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab3KDEYQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 23:24:16 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:60959 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3KDEYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 23:24:15 -0500
X-AuditID: cbfee68d-b7fa16d0000029b0-cd-5277216d06b2
Message-id: <5277216E.2080001@samsung.com>
Date: Mon, 04 Nov 2013 13:24:14 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Dongxing" <dongxing.zhang@intel.com>
Subject: Re: [PATCH] [extcon]:remove freed groups caused the panic or warning
 in unregister flow
References: <1383346094.2702.16.camel@wxm-ubuntu>
 <5276FBB5.1020506@samsung.com>
 <FA47D36D6EC9FE4CB463299737C09B9901B6467C@SHSMSX102.ccr.corp.intel.com>
 <52770837.5000901@samsung.com>
 <27240C0AC20F114CBF8149A2696CBE4A01B806F5@SHSMSX101.ccr.corp.intel.com>
In-reply-to: <27240C0AC20F114CBF8149A2696CBE4A01B806F5@SHSMSX101.ccr.corp.intel.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsWyRsSkSDdXsTzIYPMhWYvpX/YxWyz+NoXZ
	4vKuOWwWtxtXsFlcbn/H5sDqsXjPSyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgylizbQlj
	wQaOioe7zzE3MH5g62Lk5JAQMJFo61zGCmGLSVy4tx4sLiSwlFHi+Qs9mJp7c26wdzFyAcWn
	M0psutrOAuG8YpR4f3cbI0gVr4CWxIGvF5lBbBYBVYn3nefA4mxA8f0vboBNFRUIk1g5/QoL
	RL2gxI/J98BsEQEDiT/3fjCCDGUWuMEosWrfFCaQhLBAksS0r8+gtrUzSVzZ1AF0BwcHJ9Ck
	jf+qQGqYBdQlJs1bxAxhy0tsXvOWGaReQmATu0TvuVZ2iIsEJL5NPsQC0ishICux6QAzxGuS
	EgdX3GCZwCg2C8lNs5CMnYVk7AJG5lWMoqkFyQXFSelFhnrFibnFpXnpesn5uZsYgRF1+t+z
	3h2Mtw9YH2JMBlo5kVlKNDkfGJF5JfGGxmZGFqYmpsZG5pZmpAkrifMmPUwKEhJITyxJzU5N
	LUgtii8qzUktPsTIxMEp1cB4MTch7d2K/UdWyAVMvz752poPLkJpm827/5+4dOlKWORUnaDX
	+6XnHtNe9u3aMcO1BwI29UlEa8z4k1asUr6icneTwsGNmw7kSmlsuvLuoOOTEpfF3t+sD+6e
	FC68vtREw+Hv+gM88w/OU7q7oXG+w7OO/tIt8a7rWCSfRS5cNYFJ70b6w7IfukosxRmJhlrM
	RcWJANjnfJu+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xoG6uYnmQwZ4bohbTv+xjtlj8bQqz
	xeVdc9gsbjeuYLO43P6OzYHVY/Gel0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZdu
	q+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RTSaEsMacUKBSQWFyspG+HaUJoiJuu
	BUxjhK5vSBBcj5EBGkhYw5ixZtsSxoINHBUPd59jbmD8wNbFyMkhIWAicW/ODXYIW0ziwr31
	QHEuDiGB6YwSm662s0A4rxgl3t/dxghSxSugJXHg60VmEJtFQFXifec5sDgbUHz/ixtgU0UF
	wiRWTr/CAlEvKPFj8j0wW0TAQOLPvR+MIEOZBW4wSqzaN4UJJCEskCQx7eszqG3tTBJXNnUA
	3cTBwQk0aeO/KpAaZgF1iUnzFjFD2PISm9e8ZZ7AKDALyY5ZSMpmISlbwMi8ilE0tSC5oDgp
	PddQrzgxt7g0L10vOT93EyM4Yp9J7WBc2WBxiFGAg1GJh1ficlmQEGtiWXFl7iFGCQ5mJRFe
	53NAId6UxMqq1KL8+KLSnNTiQ4zJwCCYyCwlmpwPTCZ5JfGGxiZmRpZG5oYWRsbmpAkrifMe
	aLUOFBJITyxJzU5NLUgtgtnCxMEp1cC4qbHszecnAecMVllkO18quWuaGS367ILOgt9p9TJy
	9pxntBrfGpQeMC5Nmdw/UTFRa8H51y5Oqmd7HETmfxKZKPmgzT5B42JrMv8UF6vKkIDmx9fe
	Mx+o54z9qnj5xaekNKlfRepHX6zbePWN08EJVwvO5Al4PrjLPT/fbq6D64bkHxkpv48rsRRn
	JBpqMRcVJwIA7TEpZxwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 12:47 PM, Liu, Chuansheng wrote:
> 
> 
>> -----Original Message-----
>> From: Chanwoo Choi [mailto:cw00.choi@samsung.com]
>> Sent: Monday, November 04, 2013 10:37 AM
>> To: Wang, Xiaoming
>> Cc: myungjoo.ham@samsung.com; linux-kernel@vger.kernel.org; Liu,
>> Chuansheng; Zhang, Dongxing
>> Subject: Re: [PATCH] [extcon]:remove freed groups caused the panic or warning
>> in unregister flow
> 
> 
>> As you comment, my opinion has memory leak problem. My mistake.
>> But, I prefer to call 'device_unregister' at the end of extcon_dev_unregister().
>> To resolve kernel panic, I think we could use 'devm_kzalloc' instead of
>> kzalloc/kfree.
>> What is your opinion about my approach?
>>
> That sounds good.
> But in function extcon_dev_register(), the device attributes are allocated before device_register(),
> and before device_register(), the function devm_kzalloc() can not be used.
> 

We could use 'edev->dev->parent' pointer for devm_kzalloc()
but it is ambiguous method.

OK, applied this patch.

Thanks,
Chanwoo Choi

