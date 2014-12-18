Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbaLRBRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 20:17:48 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:18775 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaLRBRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 20:17:46 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfee690-f79ab6d0000046f7-62-54922b376825
Content-transfer-encoding: 8BIT
Message-id: <54922B36.8050306@samsung.com>
Date: Thu, 18 Dec 2014 10:17:42 +0900
From: Jaewon Kim <jaewon02.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Hyunhee Kim <hyunhee.kim@samsung.com>
Subject: Re: [PATCH v7 1/3] Input: add regulator haptic driver
References: <1418787308-29019-1-git-send-email-jaewon02.kim@samsung.com>
 <1418787308-29019-2-git-send-email-jaewon02.kim@samsung.com>
 <20141217220602.GC32399@dtor-ws>
In-reply-to: <20141217220602.GC32399@dtor-ws>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsWyRsSkSNdce1KIwY3tkhbXvzxntTi86AWj
	xecPLewWvQuuslnc/PSN1eLyrjlsFjPO72NyYPfYOesuu0ffllWMHp83yQUwR3HZpKTmZJal
	FunbJXBlHLjdxVpwi61ix/ptzA2MB1m7GDk5JARMJP68bmSBsMUkLtxbz9bFyMUhJLCUUaLl
	aweQwwFWNLFdASK+iFFi+aJFTCANvAKCEj8m32MBqWEWkJc4cikbJMwsYCbxqGUdM0T9a0aJ
	OY0bWSDqtSQOfVjDDlLPIqAq0TLJCCTMJqAt8X39YrB7RAUiJD6s+soGYosI6Etsn/2LEWQO
	s8BVRolzf1aDJYQF7CS2NuyAWrCKUeLrujtg3ZwCuhKzZpwC+0BC4Bi7xLv3/8A2swgISHyb
	fIgF4htZiU0HmCE+lpQ4uOIGywRGsVlI/pmF8M8sJP8sYGRexSiaWpBcUJyUXmSiV5yYW1ya
	l66XnJ+7iREYYaf/PZuwg/HeAetDjAIcjEo8vC+uTwgRYk0sK67MPcRoCnTERGYp0eR8YBzn
	lcQbGpsZWZiamBobmVuaKYnzvpb6GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBkZXN99Sb
	h9sz59wpP7HDekWRz6SEukuFj5XCU98/eXvOpFArsujz43vre1mdhfvOetocKjjWuuPAoR/P
	HtZcC2aINEpmsLm8xKFhVuk6z7mfVha/M7l/UDpq4r0bSkGsT+b0Vstu3qze+ppNOWZ57bKz
	tlxmp1fEqEpqHHv00uF9+KtrdwV8S5VYijMSDbWYi4oTAX6QZLSrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t9jAV1z7UkhBp9vCllc//Kc1eLwoheM
	Fp8/tLBb9C64ymZx89M3VovLu+awWcw4v4/Jgd1j56y77B59W1YxenzeJBfAHNXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmHHgdhdrwS22ih3rtzE3MB5k7WLk4JAQMJGY
	2K7QxcgJZIpJXLi3nq2LkYtDSGARo8TyRYuYQBK8AoISPybfYwGpZxaQlzhyKRskzCxgJvGo
	ZR0zRP1rRok5jRtZIOq1JA59WMMOUs8ioCrRMskIJMwmoC3xff1iVhBbVCBC4sOqr2wgtoiA
	vsT22b8YQeYwC1xllDj3ZzVYQljATmJrww6oBasYJb6uuwPWzSmgKzFrxim2CYwCs5DcNwvh
	vllI7lvAyLyKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzh+n0ntYFzZYHGIUYCDUYmH9+X1
	CSFCrIllxZW5hxglOJiVRHh3c00KEeJNSaysSi3Kjy8qzUktPsRoCvTdRGYp0eR8YGrJK4k3
	NDYxM7I0Mje0MDI2VxLnVbJvCxESSE8sSc1OTS1ILYLpY+LglGpgPOPSy3WVJ/Ztu/JS61MS
	s94fmVE9TWqdkPylC1nM2lbJj/9Ezrv6eibbsWkcU+wzp7pH2v/oUpL/sHl22m6m84tXcm/Q
	vi/U8r7ONnW+ZP9P7sd1kccN280+Kqd3HYzpuZMryi3w1WLO7zjx74fvnlC59XLDDMN09Rk7
	nfsL5//Vy3dgZhUTVWIpzkg01GIuKk4EAC/uns31AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmity,

2014년 12월 18일 07:06에 Dmitry Torokhov 이(가) 쓴 글:
> HI Jaewon,
>
> On Wed, Dec 17, 2014 at 12:35:06PM +0900, Jaewon Kim wrote:
>> This patch adds support for haptic driver controlled by
>> voltage of regulator. And this driver support for
>> Force Feedback interface from input framework
>>
>> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
>> Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> Does the driver still work if you apply the patch below on top of yours?
>
> Thanks.
>

Yes, there is no problem to apply this one first.

Thanks to review my patches.

Thanks
Jaewon Kim
