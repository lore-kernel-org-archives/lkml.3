Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156Ab3LGWQG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 17:16:06 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:13918 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab3LGWQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 17:16:03 -0500
X-AuditID: cbfec37a-b7f426d000003112-15-52a39e21059a
Message-id: <52A39E1F.3070905@samsung.com>
Date: Sat, 07 Dec 2013 15:15:59 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.10 00/58] 3.10.23-stable review
References: <20131206214844.906193530@linuxfoundation.org>
In-reply-to: <20131206214844.906193530@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9hX13FeYuDDC6u17WYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugStjyuxW9oJznBXHPwU2MJ5m72Lk5JAQMJFoPnOcCcIWk7hwbz1bFyMXh5DAMkaJS70T
	2CGcXiaJx0uns0I4mxglbm1dAtTCwcEroCWxe14aSDeLgKpE0/zHzCA2m4C6xOfXO8A2CAnI
	STQtWQ0WFxWIkDi6+hkriM0rICjxY/I9FhBbRCBYYu3XhYwg85kFVjBKHH/5kg0kISxgKtF8
	9A0jxCAriYP958DinALWEjturAGzmYHslZO2MULY8hKb17xlhqhXlvhz+RTYnRICihLbV1tN
	YBSZhWT1LCTds5B0L2BkXsUoVlqcXFCclJ5aYahXnJhbXJqXrpecn7uJERIxVTsY73y1OcQo
	wMGoxMNbYbEoSIg1say4MvcQowQHs5IIb/hNoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbG+u2s
	Rqxe+jK1MYyuUhkvPxkb295e8drzkW/jy/O1FzZ47Sj+4za/QUtx/5SXluuulHMe/i/yl2Pn
	iax5q1qSe5ncbe1FvVkcpX56aEv3tfl9EW1LTNnfk3r1gdh/DvurkSvMQh2Xut37onPgTUdD
	FLcB/6eP24syZSU2vlKt2fezIj9daJoSS3FGoqEWc1FxIgA9OUXLdgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 02:51 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.23 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Dec  8 21:47:53 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.23-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

patch applied cleanly.
Compile testing - passed
Boot testing - passed
dmesg regression testing - passed
dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

Test systems

     Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
     HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
     Dell OptiPlex 790 Intel(R) Core(TM) i5-2400

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
