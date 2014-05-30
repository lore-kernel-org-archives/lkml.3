Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbaE3TnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:43:14 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:9604 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaE3TnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:43:13 -0400
X-AuditID: cbfec37a-b7f206d000005572-73-5388df4f32dc
Message-id: <5388DF4C.6000205@samsung.com>
Date: Fri, 30 May 2014 13:43:08 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        satoru.takeuchi@gmail.com, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.14 000/140] 3.14.5-stable review
References: <20140529043049.661315084@linuxfoundation.org>
 <20140529155923.61a11b69@notabene.brown> <20140529141823.GA28074@kroah.com>
In-reply-to: <20140529141823.GA28074@kroah.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.245]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9hX13/+x3BBt9W8FvMWb+GzaJ58Xo2
	i8u75rBZPFl4hsli6qkJLBYLNj5itHjU95bdgd1j56y77B4nZvxm8dg/dw2Q+72B3ePzJrkA
	1igum5TUnMyy1CJ9uwSujPY565kLXrJX7NlzjaWBcSVbFyMnh4SAicTNP1OYIWwxiQv31gPF
	uTiEBJYxSmxsfswC4fQySdz9eYQdwtnGKHHgez9YO6+AlsTuQ9PZQWwWAVWJ9ofHmEBsNgF1
	ic+vd4DFhQTkJJqWrAZawcEhKhAh8fiCEESroMSPyfdYQGwRAWOJ/rOzwOYzC5xglDh9eiZY
	r7CAmcSDmT+YIeZ0MErc2pQOYnMK6Etc2n8ObBezgLXEyknbGCFseYnNa95C1StL/Ll8igni
	NWWJ5zMOskxgFJmFZPcsJO2zkLQvYGRexShWWpxcUJyUnlphqFecmFtcmpeul5yfu4kREktV
	OxjvfLU5xCjAwajEw+swoyNYiDWxrLgy9xCjBAezkgjv8yNAId6UxMqq1KL8+KLSnNTiQ4xM
	HJxSDYzWfu3/WH3tFle8mFQ/e879f+1LJsUePJnKXPDe3Mqra8s7y9hg0T07UmpmLFcp+TSt
	veX6WvUN8ivDVk78wbm1rzcq54O5x4+vcT9v39wiUbX85sppe2+freN0mfzoz79XMisfNT2x
	23/LvrHi8svWGBeHOS1bXbv0ap/+5/8d8snxf1dq76wiJZbijERDLeai4kQA82fwQ4MCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 08:18 AM, Greg Kroah-Hartman wrote:
> On Thu, May 29, 2014 at 03:59:23PM +1000, NeilBrown wrote:
>> On Wed, 28 May 2014 21:32:19 -0700 Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>
>>> This is the start of the stable review cycle for the 3.14.5 release.
>>> There are 140 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat May 31 04:30:12 UTC 2014.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.5-rc1.gz
>>> and the diffstat can be found below.
>>>
>>

Compiled and booted on my test systems. No dmesg regressions.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
