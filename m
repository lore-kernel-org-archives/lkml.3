Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaLSIct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:32:49 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:15452 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaLSIcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:32:47 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-f791c6d000004834-7f-5493e2aa5f58
Content-transfer-encoding: 8BIT
Message-id: <5493E2A9.6050407@samsung.com>
Date: Fri, 19 Dec 2014 17:32:41 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: myungjoo.ham@samsung.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "sre@kernel.org" <sre@kernel.org>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "anton@enomsg.org" <anton@enomsg.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
        =?UTF-8?B?7LWc7LCs7Jqw?= <cw00.choi@samsung.com>
Subject: Re: [PATCH RESEND v2 03/10] power: charger-manager: Remove deprecated
 function, cm_notify_event().
References: <1255984171.39711418975524329.JavaMail.weblogic@epmlwas08d>
In-reply-to: <1255984171.39711418975524329.JavaMail.weblogic@epmlwas08d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsWyRsSkQHfVo8khBkeniFoc3Kppcf3Lc1aL
	SU/eM1tMXDmZ2eLyrjlsFp97jzBa3G5cwWZx99RRNovTu0scOD0m9H9i9Ng56y67x+YVWh6b
	VnWyefRtWcXosWL1d3aPz5vkAtijuGxSUnMyy1KL9O0SuDIevvnBVNDOU3G3I6+B8QBnFyMn
	h4SAicTOqf1sELaYxIV768FsIYGljBKNV7xhalpmHmLuYuQCik9nlHi6YgEzSIJXQFDix+R7
	LF2MHBzMAvISRy5lg4SZBdQlJs1bxAwx5zWjxPSlBhDlWhKP/jxhBSlnEVCVWHDJAyTMJiAn
	8bbpGyOILSoQJnF1wnEWEFtEQEbi6sbtLCBrmQV+M0n8mjUNLCEskCtx/uhsqDvdJXbsf80K
	YnMKeEhMeNMH1iAh8JZd4uvaeWBHsAgISHybfAjsTgkBWYlNB5gh/pKUOLjiBssERrFZSL6Z
	hfDNLCTfLGBkXsUomlqQXFCclF5krFecmFtcmpeul5yfu4kRGJGn/z3r38F494D1IUYBDkYl
	Ht4HxZNDhFgTy4orcw8xmgIdMZFZSjQ5Hxj3eSXxhsZmRhamJqbGRuaWZkrivAulfgYLCaQn
	lqRmp6YWpBbFF5XmpBYfYmTi4JRqYKzcYz/L3TKx2mVV8Jr1rQsZo1c4vlil1OZ507roxV7W
	hZV15sYLdP5s2bxs9mufiJtnD9uEeyeqKU1XUFvzdGrwHIu+aSuYTbLjlsuvcdovfKZUfF5R
	lcGyVSHLq3aLK+7sO1m/6cCJtM67zjcXZxwsZ2ONrlTfty6j0ziaT3bpVSGt5Ic9c5RYijMS
	DbWYi4oTAQNZiWjDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQd1VjyaHGBzYx2txcKumxfUvz1kt
	Jj15z2wxceVkZovLu+awWXzuPcJocbtxBZvF3VNH2SxO7y5x4PSY0P+J0WPnrLvsHptXaHls
	WtXJ5tG3ZRWjx4rV39k9Pm+SC2CPamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0
	MFdSyEvMTbVVcvEJ0HXLzAE6TEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpI
	WMOY8fDND6aCdp6Kux15DYwHOLsYOTkkBEwkWmYeYoawxSQu3FvP1sXIxSEkMJ1R4umKBWAJ
	XgFBiR+T77F0MXJwMAvISxy5lA0SZhZQl5g0bxFYiZDAa0aJ6UsNIMq1JB79ecIKUs4ioCqx
	4JIHSJhNQE7ibdM3RhBbVCBM4uqE4ywgtoiAjMTVjdtZQNYyC/xmkvg1axpYQlggV+L80dls
	EPPdJXbsf80KYnMKeEhMeNPHMoFRYBaS62YhXDcLyXULGJlXMYqmFiQXFCel5xrqFSfmFpfm
	pesl5+duYgRH/DOpHYwrGywOMQpwMCrx8HYUTg4RYk0sK67MPcQowcGsJMLreBwoxJuSWFmV
	WpQfX1Sak1p8iNEU6LmJzFKiyfnAZJRXEm9obGJmZGlkbmhhZGyuJM6rZN8WIiSQnliSmp2a
	WpBaBNPHxMEp1cC458k04YPbTd0eRCyZ7iC/U0Jb8Zhim4V5l2hoxAfvrMn9n+yt/b+tbv54
	4iTHUsEnf6x33Zv24HOTtf6OlNgD/w5+KdnEwh5+IPGMt/KkeRKfdqx31qjcKbjfqa5dbvaG
	1Z2yEp4i8pV3ewU/9z8V5Ng3c/OyjQZTGX+ePFqrrLf8pdWmf9emKrEUZyQaajEXFScCAKFZ
	nAQOAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 12월 19일 16:52, MyungJoo Ham wrote:

>>   
>>  cm_notify_event() is introduced to get event associated with battery status
>> externally, but no one had been used. Moreover it makes charger manager
>> driver more complicated. This patch tries to drop the function and all data
>> related to simplify the driver.
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> 
> You are not just removing cm_notify_event() and its related.
> 
> You are hereby removing the much of software charger control
> and suspend-related operations. Could you please be more specific
> on why? (many of such features are to comply with operators' requirements)
> 


Unfortunately, all those codes are only for cm_notify_event(). Currently, and
since charger-manager has been introduced then, there's no one to use it. And
the works of cm_notify_event() are is just notifying the event to user space or
reset the polling work. We may need passive method to get event related with
battery status externally, if so we can use power_supply class notification
method, power_supply_notifier.

I decided to remove it to make driver simple and clean.

Thanks,
Jonghwa


> (Or we may meet next Monday for some discussions :) )
> 
>> ---
>>  .../bindings/power_supply/charger-manager.txt      |    1 -
>>  drivers/power/charger-manager.c                    |  196 +-------------------
>>  include/linux/power/charger-manager.h              |   19 +-
>>  3 files changed, 8 insertions(+), 208 deletions(-)
>>


