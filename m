Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbaBLS5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:57:33 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:54748 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbaBLS5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:57:31 -0500
X-AuditID: cbfec37a-b7ef66d000004f2b-99-52fbc41a2415
Message-id: <52FBC417.5010408@samsung.com>
Date: Wed, 12 Feb 2014 11:57:27 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.10 00/79] 3.10.30-stable review
References: <20140211184720.928667275@linuxfoundation.org>
 <20140212042037.GB26490@roeck-us.net>
In-reply-to: <20140212042037.GB26490@roeck-us.net>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.3]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9hX13pI7+DDNa+YrKYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugSvj3+m3LAUtXBWzmpexNTA2c3QxcnJICJhIHG7+wghhi0lcuLeerYuRi0NIYBmjxLbf
	T5khnF4mic/n1rFCOBsYJfrur2cCaeEV0JI4c/4hmM0ioCrxbsoiNhCbTUBd4vPrHewgtpCA
	nETTktXMILaoQITEq7MTWSB6BSV+TL4HZosIGEv0n50FVs8scIxRYmGzCYgtLGAqse1mNyvE
	nCSJA0/+gM3hFDCSmLB+EitEvbXEyknbGCFseYnNa94yQ9QrS/y5fIoJ4jUFifUXDrNOYBSZ
	hWT1LCTts5C0L2BkXsUoVlqcXFCclJ5aYahXnJhbXJqXrpecn7uJERI1VTsY73y1OcQowMGo
	xMNrsex3kBBrYllxZe4hRgkOZiURXqNmoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGr5tMLT82
	NKZPWfQnKFJeIvWq2dfwT50J29V5fb9un3bssvwxt4PLN3Kej5l8ksHvxz25a1qiP4/b8PZ0
	SO11sYkpVHEu6ZtV9TuTMeFq1rpNTekFzvavE82an4e92OfwtW/3+y1tO2pFsnkqwjkNjfJ0
	9NfOsP49o+H3zzyxxIC3niqv4gKVWIozEg21mIuKEwHoQ25SeAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 09:20 PM, Guenter Roeck wrote:
> On Tue, Feb 11, 2014 at 11:05:04AM -0800, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 3.10.30 release.
>> There are 79 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu Feb 13 18:46:56 UTC 2014.
>> Anything received after that time might be too late.
>>
> Build results:
> 	total: 126 pass: 121 skipped: 4 fail: 1
>
> qemu tests all passed.
>
> Results are as expected.
>
> Details are available at http://server.roeck-us.net:8010/builders.
>
> Guenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

Worked fine on all my test systems. Compile tests and boot tests passed. 
No dmesg regressions: emerg, crit, alert, err are clean. No regressions 
in warn.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
