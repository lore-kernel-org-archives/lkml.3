Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab3BFMnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 07:43:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:33110 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3BFMng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 07:43:36 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7fb06d000000f28-ff-51124ff609fb
Content-transfer-encoding: 8BIT
Message-id: <51124FF2.2070605@samsung.com>
Date: Wed, 06 Feb 2013 21:43:30 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: Re: [PATCH] rtc: Modify leap year test for more simpler way
References: <1360149775-19606-1-git-send-email-jonghwa3.lee@samsung.com>
 <D958900912E20642BCBC71664EFECE3E6E1B6C6A52@BGMAIL02.nvidia.com>
In-reply-to: <D958900912E20642BCBC71664EFECE3E6E1B6C6A52@BGMAIL02.nvidia.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t8zPd1v/kKBBk/uylhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MQ6+eMha0iFQcmbWarYFxmUAXIyeHhICJxPWtU9khbDGJC/fW
	s3UxcnEICSxjlNh28QETTNHS74cYQWwhgUWMEgvXV4PYvAKCEj8m32PpYuTgYBaQlzhyKRsk
	zCygLjFp3iJmiDldTBIdTUtYIOq1JOa9uskMYrMIqEpcWHaVDcRmE5CTeNv0jRFkjqhAhMSv
	fg6QsIiAjkTv81ZGkDnMAm1MEs8uvmEHqREWcJGYsFMH4pxuRoldbTYgNqeAr0T3j/+sIPUS
	At3sEjcO/IbaJSDxbfIhsDslBGQlNh1ghnhLUuLgihssExjFZiH5ZhbCN7OQfLOAkXkVo2hq
	QXJBcVJ6rpFecWJucWleul5yfu4mRkg0SO9gXNVgcYhRgINRiYf3hp5goBBrYllxZe4hRgkO
	ZiUR3jwnoUAh3pTEyqrUovz4otKc1OJDjMlA901klhJNzgdGal5JvKGxgbGhoaWhmamlqQFp
	wkrivIynngQICaQnlqRmp6YWpBbBbGHi4JRqYNzsV+vxzO+3j0+aa+kUhxNTNlo86z//17N7
	wcKFehnzjDccvKsZZnr06pV1+y4sZnI/H2//51Fx1opNC3UmcLJ4fqy83rnWMLTSIE3byVTM
	pT/omsNJvjMdJ4QfCB3jum29xbSr+7LNEde8O5GK7YmRK9QTn3UxMrmU//62zvgL48LJplfe
	eiqxFGckGmoxFxUnAgDtoD7cygIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jAd1v/kKBBtd2iFhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjEOvnjIWtIhUHJm1mq2B
	cZlAFyMnh4SAicTS74cYIWwxiQv31rOB2EICixglFq6vBrF5BQQlfky+x9LFyMHBLCAvceRS
	NkiYWUBdYtK8RcxdjFxA5V1MEh1NS1gg6rUk5r26yQxiswioSlxYdhVsJpuAnMTbpm+MIHNE
	BSIkfvVzgIRFBHQkep+3MoLMYRZoY5J4dvENO0iNsICLxISdOhDndDNK7GqzAbE5BXwlun/8
	Z53AKDALyXWzEK6bheS6BYzMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCY+2Z9A7GVQ0W
	hxgFOBiVeHhv6AkGCrEmlhVX5h5ilOBgVhLhzXMSChTiTUmsrEotyo8vKs1JLT7EmAz020Rm
	KdHkfGAayCuJNzQ2MTOyNDIzNjE3NiZNWEmcl/HUkwAhgfTEktTs1NSC1CKYLUwcnFINjJ6i
	0a6r3gUGt/b27n+VyMdV3DPnhvixX55CXAvdV2WWzDxynKXj05uqtk3nn23m9KlbGxi9oPFx
	4dzP8hVz969/6eRmdyHQye/QpLr5qeJnyi8eDOXcLbYqZon0J7es0O7or7/WTbqbV1JRsPL4
	8YecjKr8T4pPJrSIbQi+zDjL7+A2juCPXkosxRmJhlrMRcWJAAO9Bvv5AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013년 02월 06일 20:42, Venu Byravarasu wrote:
> By definition, leap year is one, which is a divisible by 4 & 400, excluding multiples of 100s.
> Hence I feel this patch is not correct.

No, I think you might misunderstood the it's meaning. The former code checks
whether if it is multiple of 4 or not. Formal mathematical way to verify multiple of 4
is just checks the last two digits are multiple of 4. This '(!year % 4) && (year % 100)'
part does it. But with only that checking, it may miss the case of multiple of 400 which
is also multiple of 4. Then my modification checks in hexadecimal, whether if number
has any of 1st and 2nd bit with value 1. Because any number which has all bits above
the 3rd can be divided with 4(2^2).
(e.g. 44(0b101100) = 2^5+2^3+2^2 = 2^2(2^3 + 2 + 1))
So It does same things with less instructions.
> Thanks,
> Venu
>
>
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Jonghwa Lee
>> Sent: Wednesday, February 06, 2013 4:53 PM
>> To: linux-kernel@vger.kernel.org
>> Cc: a.zummo@towertech.it; Andrew Morton; rtc-linux@googlegroups.com;
>> Jonghwa Lee
>> Subject: [PATCH] rtc: Modify leap year test for more simpler way
>>
>> Leap year which is multiple of 4, just needed 2 LSB for verifying.
>> A year with zero for all thease two bits means that it is leap year.
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> ---
>>  include/linux/rtc.h |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/rtc.h b/include/linux/rtc.h
>> index 9531845..d662b8d 100644
>> --- a/include/linux/rtc.h
>> +++ b/include/linux/rtc.h
>> @@ -181,7 +181,7 @@ void rtc_timer_do_work(struct work_struct *work);
>>
>>  static inline bool is_leap_year(unsigned int year)
>>  {
>> -	return (!(year % 4) && (year % 100)) || !(year % 400);
>> +	return !(year & 0x3);
>>  }
>>
>>  #ifdef CONFIG_RTC_HCTOSYS_DEVICE
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

