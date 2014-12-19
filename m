Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaLSIWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:22:01 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:12765 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbaLSIV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:21:59 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-f79ab6d0000046f7-1f-5493e01eba1f
Content-transfer-encoding: 8BIT
Message-id: <5493E01E.6090806@samsung.com>
Date: Fri, 19 Dec 2014 17:21:50 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: myungjoo.ham@samsung.com
Cc: =?UTF-8?B?7J207KKF7ZmU?= <jonghwa3.lee@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "sre@kernel.org" <sre@kernel.org>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "anton@enomsg.org" <anton@enomsg.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
        =?UTF-8?B?7LWc7LCs7Jqw?= <cw00.choi@samsung.com>
Subject: Re: [PATCH RESEND v2 02/10] power: charger-manager: Use
 power_supply_changed() not private uevent.
References: <1443120167.38671418974875751.JavaMail.weblogic@epmlwas08d>
In-reply-to: <1443120167.38671418974875751.JavaMail.weblogic@epmlwas08d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsWyRsSkQFfuweQQg/mfzS0ObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEdx2aSk5mSWpRbp2yVwZTx5/5KloEGg4sj/QywN
	jBN5uxg5OSQETCRWbv3MDGGLSVy4t56ti5GLQ0hgKaPE7tMv2WGKvp+eyw6RmM4osbz7ICNI
	gldAUOLH5HssXYwcHMwC8hJHLmWDhJkF1CUmzVvEDFH/mlFi4/K7bBD1WhIf9l9iBbFZBFQl
	fh++yAJiswnISbxt+gY2U1QgTOLqhONgcREBGYmrG7ezgAxiFtjELPHq7zewi4QFciV+N/0H
	Gyok4C4xr/sOE8gRnAIeEs3//EDqJQS+skt0TzgPtUxA4tvkQ2CHSgjISmw6APWxpMTBFTdY
	JjCKzULyziyEd2YheWcBI/MqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjMAIPf3v2YQdjPcO
	WB9iFOBgVOLhfVA8OUSINbGsuDL3EKMp0BETmaVEk/OBaSCvJN7Q2MzIwtTE1NjI3NJMSZz3
	tdTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MSvd+pUXocTA8txC8uOaOkcD5+Gqvdyz9
	E8sTHl0tmDuPS4p5S5ceq3Vg58seNt+7Uzr4TvFoLc6qvLvMRnTdjDdSObuLO2+fndrypjko
	MUl6Qdy5yW92VrYrrj+VxnXm4N7mZPbHDgXuTN833pvoneP999ilOoN9auKJbEeigmTEDWVC
	FTYqsRRnJBpqMRcVJwIAJj6bMMsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xoK7cg8khBt239S0ObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZ
	GOoaWlqYKynkJeam2iq5+AToumXmAF2npFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiu
	x8gADSSsYcx48v4lS0GDQMWR/4dYGhgn8nYxcnJICJhIfD89lx3CFpO4cG89WxcjF4eQwHRG
	ieXdBxlBErwCghI/Jt9j6WLk4GAWkJc4cikbJMwsoC4xad4iZoj614wSG5ffZYOo15L4sP8S
	K4jNIqAq8fvwRRYQm01ATuJt0zewmaICYRJXJxwHi4sIyEhc3bidBWQQs8AmZolXf7+BXSQs
	kCvxu+k/2FAhAXeJed13mECO4BTwkGj+5zeBUWAWkvNmIZw3C8l5CxiZVzGKphYkFxQnpeca
	6hUn5haX5qXrJefnbmIEx/8zqR2MKxssDjEKcDAq8fB2FE4OEWJNLCuuzD3EKMHBrCTC63gc
	KMSbklhZlVqUH19UmpNafIjRFOi5icxSosn5wNSUVxJvaGxiZmRpZG5oYWRsriTOq2TfFiIk
	kJ5YkpqdmlqQWgTTx8TBKdXAyKbMPpdJ4+3Nm76nWJJbF3wqWrpKJiB8tcD+b8sqXjzastE8
	a0re4ssa1d5cgWH9Lp9yenbeFpxwKyey61KWetsfa/vmfTea0ydsjLl26Vvi1bg7e52/rlGW
	43Pselb79nxJbNYNxuhHm01b/OU/TzLeut3S6eZLs9IHfLfy5IQnnij6z7PQVomlOCPRUIu5
	qDgRAONmTKQVAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 12월 19일 16:41, MyungJoo Ham wrote:

>>   
>>  Whenever battery status is changed, charger manager tries to trigger uevent
>> through private interface. This patch modifies it to use power_supply_changed()
>> since it belongs to power supply subsystem.
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> 
> The original uevent_notify() has two additional mechanisms:
> C1. Save events in suspend-again context and show them up at wakeup.
> C2. If the new event is a duplicated event, ignore it.
> 
> Questions:
> Q1. Have you checked if C1 is met with the modification? Besides, have
> you made it sure that the modification won't change the behavior of
> suspend-again context? (whether "theoretical" or "experimental")


It won't ruin suspend-again context because it just changes the location where
the charger manager's notice to go.

> Q2. Do you still support C2?
>   For example, if we have notifited the user that we are charging
>   30 seconds ago, we should never bother the user with another message
>   that declares that it is charging unless we have notified that
>   we are not charging since then.
> 


Above case never happens. If charging state is not changed, the report will not
be triggered. Maybe current driver will send same event repeatedly even though,
these patch series will guarantee not to do so.

And also if we have a status changing while short time wake-up which expects
suspend-again proceeds in near future, I think it is better to notify it to the
user not to keep until undetermined 'TRUE' wake-up.

Thanks,
Jonghwa

> Cheers,
> MyungJoo.
> 
>> ---
>>  drivers/power/charger-manager.c |   91 +++++----------------------------------
>>  1 file changed, 11 insertions(+), 80 deletions(-)
>>
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{��h����ܨ}���Ơz�&j:+v�������zZ+��+zf���h���~����i���z��w���?����&�)ߢfl===


