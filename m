Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaANAPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:15:12 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:52264 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaANAPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:15:09 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-04-52d48188d159
Message-id: <52D4818A.3050905@samsung.com>
Date: Tue, 14 Jan 2014 09:15:06 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Alexey Perevalov <a.perevalov@samsung.com>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        Anton Vorontsov <anton@scarybugs.org>, anton@enomsg.org,
        kyungmin.park@samsung.com, akpm@linux-foundation.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH v2 1/3] kernel/time: Add new helpers to convert ktime
 to/from jiffies
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com>
 <1389609835-24377-2-git-send-email-a.perevalov@samsung.com>
In-reply-to: <1389609835-24377-2-git-send-email-a.perevalov@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsWyRsSkQLej8UqQwf+74hZz755nsZizfg2b
	xcXW2ywWB7dqWrQ+7mS1OPNb1+Js0xt2i8u75rA5cHhM6P/E6HHn2h42jxMzfrN49G1Zxejx
	+PBqFo/Pm+QC2KK4bFJSczLLUov07RK4MtqvH2EpWMBWcf3/aqYGxumsXYycHBICJhKbvm9h
	g7DFJC7cWw9kc3EICSxllHj/chcbTNG2k7NZIRKLGCVetF9lgXBeMUrMu3KfGaSKV0BLovfJ
	WXYQm0VAVaJ1wWIwmw0ovv/FDbBJogJhEiunX2GBqBeU+DH5HpgtIqAnsfzld7A5zAK3GSUe
	LzbvYuTgEBaIlmifLAESFhJoBdq1QQkkzCngIfH3YxZEtY7E/tZpbBC2vMTmNW+ZQU6TELjG
	LrFg9WQmiHMEJL5NPsQC0ishICux6QAzxF+SEgdX3GCZwCg2C8lBs5CMnYVk7AJG5lWMoqkF
	yQXFSelFhnrFibnFpXnpesn5uZsYgVF4+t+z3h2Mtw9YH2JMBlo5kVlKNDkfGMV5JfGGxmZG
	FqYmpsZG5pZmpAkrifMmPUwKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cCo3uYstoX1XnPL
	gq8m9Sx+H5salp188KHBeImB2lIXh3CmZQ+TA5NVSq18P87fdGj9JmO2z6FTY8Q29hass2Y5
	X7xrX27QlJ5Fp9rKFRv+zLKducRZ/cQGgeULf7Jodi/iFgurmnKt6H71wt1xC4SfJ3mtdZtX
	8txz48o9jpsN7+xIKkgt0ClWYinOSDTUYi4qTgQAKGJ9+dgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jAd2OxitBBjNbBCzm3j3PYjFn/Ro2
	i4utt1ksDm7VtGh93Mlqcea3rsXZpjfsFpd3zWFz4PCY0P+J0ePOtT1sHidm/Gbx6NuyitHj
	8eHVLB6fN8kFsEU1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5
	+AToumXmAN2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcxov36EpWAB
	W8X1/6uZGhins3YxcnJICJhIbDs5G8oWk7hwbz1bFyMXh5DAIkaJF+1XWSCcV4wS867cZwap
	4hXQkuh9cpYdxGYRUJVoXbAYzGYDiu9/cYMNxBYVCJNYOf0KC0S9oMSPyffAbBEBPYnlL7+D
	zWEWuM0o8XixeRcjB4ewQLRE+2QJkLCQQCvQrg1KIGFOAQ+Jvx+zIKp1JPa3TmODsOUlNq95
	yzyBUWAWkgWzkJTNQlK2gJF5FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwjD+T2sG4ssHi
	EKMAB6MSD+8JxitBQqyJZcWVuYcYJTiYlUR4l9cBhXhTEiurUovy44tKc1KLDzEmA/0/kVlK
	NDkfmH7ySuINjU3MjCyNzA0tjIzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoHR6f6v
	fSbbvDUmaDM+ZeHki9p3ISlDN3Wq2m8Wn92brsfMuJVxs6vmm9avj7vPlXF1HH4xc9KLQ17T
	KmXj11hcdnh+6s+P4y8OBH26lZ0Z8/d5ZmBp5v7A2w8v3UtY+utd7ufoUrfr9T2sSb90hLdG
	ut+RMHBkW/d19sz59nMOlfW0+ugm2V8+qsRSnJFoqMVcVJwIAPCv5Is1AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 07:43 PM, Alexey Perevalov wrote:
> From: Anton Vorontsov <anton@scarybugs.org>
> 
> Two new functions: jiffies_to_ktime() and ktime_to_jiffies(), we'll use
> them for timerfd deferred timers handling.
> 
> We fully reuse the logic from timespec implementations, so the functions
> are pretty straightforward.
> 
> The only tricky part is in headers: we have to include jiffies.h after
> we defined ktime_t, this is because ktime.h needs some declarations from
> jiffies.h (e.g. TICK_NSEC).
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>

Tested-by: Chanwoo Choi <cw00.choi@samsung.com>

I tested this patchset about operation of deferrable timer on user-space.

Thanks,
Chanwoo Choi

