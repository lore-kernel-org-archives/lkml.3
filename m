Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbaG3BDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:03:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54907 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbaG3BDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:03:38 -0400
X-AuditID: cbfee691-b7f306d000003d81-81-53d844688515
Message-id: <53D84468.6070001@samsung.com>
Date: Wed, 30 Jul 2014 10:03:36 +0900
From: Sangjung <sangjung.woo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>, Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        again4you@gmail.com, Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] Documentation: fix a typo in watchdog-api.txt
References: <1406621064-5466-1-git-send-email-sangjung.woo@samsung.com>
 <53D7D02D.6010508@infradead.org>
In-reply-to: <53D7D02D.6010508@infradead.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsWyRsSkRDfD5UawwdP5mhYn+/tZLC7vmsNm
	cWPdPnaLt3ems1i833+ZyeLWjBesDmweO2fdZfe4tlnMY/MKLY9NqzrZPD5vkgtgjeKySUnN
	ySxLLdK3S+DK6G25yV7QyVXReWMPewPjC/YuRk4OCQETie2L1zFB2GISF+6tZ+ti5OIQEljK
	KHH14XaWLkYOsKJF3zQh4tMZJTa/28UK4bxmlJj//RUbSDevgJbEj6kNrCA2i4CqxN3W5WA2
	m4CmxOfjB8FqRAUiJO41HmaFqBeU+DH5HguILSLgJfHl+GmwK5gFKiUWLJjEDGILCzhJvH+6
	A+xSIYEsiU/PNrOBHMQpoCuxoSccotxaYuWkbYwQtrzE5jVvmUFukxA4xi4x4e0iNoh7BCS+
	TT4E9YysxKYDzBAPS0ocXHGDZQKj2CwkF81CMnYWkrELGJlXMYqmFiQXFCelF5nqFSfmFpfm
	pesl5+duYgTG2el/zybuYLx/wPoQYzLQyonMUqLJ+cA4zSuJNzQ2M7IwNTE1NjK3NCNNWEmc
	N/1RUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRt7jZoIiD/7znNw2eeo+TwazbxdT7qgs
	kjBX8rjzqmnepWVW235tTnI/rvTKg5kx9UHR9wkp72TX+XjfTTiq/v3WkwvHbx/OZ5263/H3
	wYkJx9LOL9zx7YVovITh8j5vjct3DNqdhWImlqVv0Rc6fUajJO2+gghL0OxZFR2ZV1tkDzEw
	Nyz/skaJpTgj0VCLuag4EQA2NX6uyQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jQd0MlxvBBot2KVmc7O9nsbi8aw6b
	xY11+9gt3t6ZzmLxfv9lJotbM16wOrB57Jx1l93j2mYxj80rtDw2repk8/i8SS6ANaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY0Zvy032gk6uis4be9gbGF+wdzFycEgI
	mEgs+qbZxcgJZIpJXLi3nq2LkYtDSGA6o8Tmd7tYIZzXjBLzv79iA6niFdCS+DG1gRXEZhFQ
	lbjbuhzMZhPQlPh8/CBYjahAhMS9xsOsEPWCEj8m32MBsUUEvCS+HD/NBGIzC1RKLFgwiRnE
	FhZwknj/dAc7iC0kkCXx6dlmNpDjOAV0JTb0hEOUW0usnLSNEcKWl9i85i3zBEaBWUg2zEJS
	NgtJ2QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwVH8THoH46oGi0OMAhyMSjy8M/5f
	DxZiTSwrrsw9xCjBwawkwvtV7kawEG9KYmVValF+fFFpTmrxIUZTYABMZJYSTc4HJpi8knhD
	YxMzI0sjc0MLI2NzJXHeg63WgUIC6YklqdmpqQWpRTB9TBycUg2MfFuWFtpcuFa02CfT7V5R
	0cq3y5R2lWdud2uz/cW1bKtbhW/0msdbv1XIG7/IO6r5+dqTI9e6F12Zmr7xz8GO96LLJnq2
	hMq9M/a6VrBAsObL5itW4ayn+j901Lcoajj1mH36LnPm84zUq/KHNW8vchS8pHV1nv0O+Xyt
	VSd1LmdOfhajWcD7RomlOCPRUIu5qDgRAKEl7nf4AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07/30/2014 01:47 AM, Randy Dunlap wrote:
> On 07/29/14 01:04, Sangjung Woo wrote:
>> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
>> ---
>>   Documentation/watchdog/watchdog-api.txt |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Documentation/watchdog/watchdog-api.txt b/Documentation/watchdog/watchdog-api.txt
>> index eb7132e..53c49a4 100644
>> --- a/Documentation/watchdog/watchdog-api.txt
>> +++ b/Documentation/watchdog/watchdog-api.txt
>> @@ -118,7 +118,7 @@ resets.
>>   Note that the pretimeout is the number of seconds before the time
>>   when the timeout will go off.  It is not the number of seconds until
>>   the pretimeout.  So, for instance, if you set the timeout to 60 seconds
>> -and the pretimeout to 10 seconds, the pretimout will go of in 50
>> +and the pretimeout to 10 seconds, the pretimout will go off in 50
>                                           pretimeout
>
> Please correct that word also and then resend.  Also resend to:
> trivial@kernel.org
>
> Thanks.

I resent it after modification.
Thanks for your opinion.

Best regards,
Sangjung

>
>>   seconds.  Setting a pretimeout to zero disables it.
>>   
>>   There is also a get function for getting the pretimeout:
>>
>

