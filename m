Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbbATM5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:57:24 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44045 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbbATM5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:57:21 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-5b-54be50aed37b
Message-id: <54BE50AD.7080801@samsung.com>
Date: Tue, 20 Jan 2015 13:57:17 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v10 05/19] mfd: max77693: Modify flash cell name
 identifiers
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-6-git-send-email-j.anaszewski@samsung.com>
 <20150120111346.GD13701@x1>
In-reply-to: <20150120111346.GD13701@x1>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xy7rrAvaFGHybIGWxccZ6VoujOycy
	WVz/8pzVYv6Rc6wWZ5vesFvc/3qU0eLyrjlsFlvfrGO06NmwldXi7qmjbBa7dz1ltTj8pp3V
	4sz+lWwOvB47Z91l9zj8dSGLx51re9g89sz/werRt2UVo8eK1d/ZPT5vkgtgj+KySUnNySxL
	LdK3S+DKWN83kbmgnbNi9pmJ7A2MS9i7GDk5JARMJJ7dnsQEYYtJXLi3nq2LkYtDSGApo0Tn
	408sEM5HRomnjxtZQap4BbQkGi8fA+tgEVCV2LDzOwuIzSZgKPHzxWuwuKhAhMSf0/ug6gUl
	fky+B1TDwSEioCJx7o05SJhZYBeTxL7jGiC2sECYxMw3a6B2LWaUWLNgLtgcTgENiUUP2xkh
	GswkHrWsY4aw5SU2r3nLPIFRYBaSFbOQlM1CUraAkXkVo2hqaXJBcVJ6rqFecWJucWleul5y
	fu4mRkjcfNnBuPiY1SFGAQ5GJR5ejZw9IUKsiWXFlbmHGCU4mJVEeM+a7wsR4k1JrKxKLcqP
	LyrNSS0+xMjEwSnVwCh59M7l1xMuipqpeD045Hj4sN1Lo7vlsVt2P3B59OCkwY8Fa2cFnJOU
	kggWWbt1DVf5mTO8j759O//Frm6OZbwBz0Krt1Vtk/6uUXcrLM8q8C9u1Snr+fXdvPOLy6Ut
	enuDL/Gl/kmryC9wulR5j8FDT+DU7YvF/OwXrXh/748r/HF9mUX5GQclluKMREMt5qLiRADT
	GaRseQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 12:13 PM, Lee Jones wrote:
> On Fri, 09 Jan 2015, Jacek Anaszewski wrote:
>
>> Change flash cell identifiers from max77693-flash to max77693-led
>> to avoid confusion with NOR/NAND Flash.
>
> This is okay by me, but aren't these ABI yet?

No, the led driver using it hasn't been merged yet.

>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> ---
>>   drivers/mfd/max77693.c |    4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
>> index a159593..cb14afa 100644
>> --- a/drivers/mfd/max77693.c
>> +++ b/drivers/mfd/max77693.c
>> @@ -53,8 +53,8 @@ static const struct mfd_cell max77693_devs[] = {
>>   		.of_compatible = "maxim,max77693-haptic",
>>   	},
>>   	{
>> -		.name = "max77693-flash",
>> -		.of_compatible = "maxim,max77693-flash",
>> +		.name = "max77693-led",
>> +		.of_compatible = "maxim,max77693-led",
>>   	},
>>   };
>>
>


-- 
Best Regards,
Jacek Anaszewski
