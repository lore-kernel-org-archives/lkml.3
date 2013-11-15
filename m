Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab3KOW2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 17:28:21 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:38298 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab3KOW2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 17:28:09 -0500
X-AuditID: cbfec37c-b7fd86d00000670b-66-52869ff76faa
Message-id: <52869FE7.3050101@samsung.com>
Date: Fri, 15 Nov 2013 15:27:51 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Joe Perches <joe@perches.com>
Cc: len.brown@intel.com, pavel@ucw.cz, rjw@rjwysocki.net,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH] power: Replace printks with pr_* routines
References: <1384531806-11500-1-git-send-email-shuah.kh@samsung.com>
 <20131115211922.GB14410@kroah.com> <1384551981.18739.36.camel@joe-AO722>
 <20131115221057.GA16530@kroah.com>
In-reply-to: <20131115221057.GA16530@kroah.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t9hP93v89uCDKY9t7ZoXryezWL2/ccs
	FrOm7GWyuLxrDpvF594jjBZ3Tx1lszhz+hKrxdefDg4cHjtn3WX3WLznJZPH/rlr2D2+rLrG
	7LHlajuLx4rV39k9Pm+SC2CP4rJJSc3JLEst0rdL4Mp4eHEhU8EkjorlV1+zNzBuZeti5OSQ
	EDCRWPngMDOELSZx4d56oDgXh5DAMkaJnpefWEESQgK9TBJLOuogEhsZJRb8e8QOkuAV0JL4
	9O85WBGLgKrEnSv3wOJsAuoSn1/vYIdolpNoWrIabIOoQITE0dXPWCF6BSV+TL7HAmKLCLhL
	XH58lQVkAbPAGkaJrTdugBUJC9hJLD52lBli8xZGiX3L24Du4+DgFNCX+HcsBKSGWcBaYuWk
	bYwQtrzE5jVvmSEWK0v8uXyKCaRcQkBRYvtqqwmMIrOQrJ6FpHsWku4FjMyrGMVKi5MLipPS
	UyuM9YoTc4tL89L1kvNzNzFCoqxmB+O9rzaHGAU4GJV4eBP82oKEWBPLiitzDzFKcDArifAe
	mg0U4k1JrKxKLcqPLyrNSS0+xMjEwSnVwDj3zp7ZWmIWJZzvV145JmDPEL0iIrLU8LyDikPD
	a6cpf97f8Nf+c1rk87VyzpvqV1QE49LMW9Wk6t6tE2Gr3WxoISVsefnhyQ1/Ch5xrSw53O3v
	tZRJ7fdqeY7lVz3O3GCyXXOk8H/PLe/vt2esiecqv+shbi+z5U/5KQGzjxZr2C9Y+qQJSCix
	FGckGmoxFxUnAgDOsgQLkAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 03:10 PM, Greg KH wrote:
> On Fri, Nov 15, 2013 at 01:46:21PM -0800, Joe Perches wrote:
>> On Sat, 2013-11-16 at 06:19 +0900, Greg KH wrote:
>>> On Fri, Nov 15, 2013 at 09:10:06AM -0700, Shuah Khan wrote:
>>>> Replaced printks with pr_* routines. dev_* routines could have been used,
>>>> but chose to use pr_* to avoid breaking scripts that might be relying on
>>>> a specific text.
>>>
>>> I'd really like to switch to dev_* instead, even changing to pr_* should
>>> change the output prefix (if it's set for this file, odds are it isn't
>>> though...)
>>
>> It's not.
>>
>> Something like this?
>>
>> Pass a struct device * through to the PM
>> suspend logging routines.  Use dev_<level>
>> instead of printks.
>
> That looks good to me, Shuah, does it work for you?
>
> greg k-h
>

Looks good to me. I will update and re-send the patch.

-- Shuah
-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
