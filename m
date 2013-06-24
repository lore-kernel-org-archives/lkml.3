Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab3FXLSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:18:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26423 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab3FXLSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:18:51 -0400
X-AuditID: cbfee68f-b7f436d000000f81-b3-51c82b1abbdd
Message-id: <51C82B1A.30906@samsung.com>
Date: Mon, 24 Jun 2013 20:18:50 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v2] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
References: <1371716524-19370-1-git-send-email-cw00.choi@samsung.com>
 <3966081.PYqoVoQ0Wq@vostro.rjw.lan>
 <CAKohponJ7WZ9pc20653gj_bPEAC_ZCA43XgZVPmNBcBs7pLFAQ@mail.gmail.com>
 <4710866.fhlicB7Bsa@vostro.rjw.lan>
In-reply-to: <4710866.fhlicB7Bsa@vostro.rjw.lan>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsWyRsSkQFdK+0SgwerPBhZnm96wW1zeNYfN
	4nbjCjaL/oW9TBYbv3o4sHrcubaHzaNvyypGj0eLWxg9Pm+SC2CJ4rJJSc3JLEst0rdL4MrY
	sXI1Y8FU7orV7/axNjA2cHYxcnJICJhIPJm4lwXCFpO4cG89G4gtJLCUUeL7SasuRg6wmgWP
	yiDCixglNqzk6mLkArJfMEqs+niTFaSGV0BD4lizO4jJIqAqseKBAEg5m4CWxP4XN8AmigqE
	SaycfgVsE6+AoMSPyffAbBGg8i1P/rODjGQWWMAoMffyamaQOcICGRIT3lZBrLrBKPHp7Rl2
	kAZOAQOJ15/6wJqZBdQlJs1bxAxhy0tsXvOWGaRBQmAfu0T/g1tgCRYBAYlvkw+xQPwiK7Hp
	ADPEu5ISB1fcYJnAKDYLyU2zkIydhWTsAkbmVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxiB
	EXX637P+HYx3D1gfYkwGWjmRWUo0OR8YkXkl8YbGZkYWpiamxkbmlmakCSuJ86q1WAcKCaQn
	lqRmp6YWpBbFF5XmpBYfYmTi4JRqYOTh2Xz0X+IJo9UKqz/tljndpbHomW7xybRW6aeT++ZU
	1C7KfKC1Z9k5tiKzv1nWVh63V66NOWI3y8RNy9y+L7b1i7/ktnr94Gd3JHeeejaLr/jL5MjP
	C/cetW+sdYx5Hfk35/Cuez+OzrAtchTuWqweUbBgS7fvt/t+C1i8+ndP+LFn293JLZOUWIoz
	Eg21mIuKEwHVRdI/vgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xgK6U9olAg88vNSzONr1ht7i8aw6b
	xe3GFWwW/Qt7mSw2fvVwYPW4c20Pm0ffllWMHo8WtzB6fN4kF8AS1cBok5GamJJapJCal5yf
	kpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0V0mhLDGnFCgUkFhcrKRvh2lC
	aIibrgVMY4Sub0gQXI+RARpIWMOYsWPlasaCqdwVq9/tY21gbODsYuTgkBAwkVjwqKyLkRPI
	FJO4cG89G4gtJLCIUWLDSq4uRi4g+wWjxKqPN1lB6nkFNCSONbuDmCwCqhIrHgiAlLMJaEns
	f3EDrFVUIExi5fQrLCA2r4CgxI/J98BsEaDyLU/+s4OMZBZYwCgx9/JqZpA5wgIZEhPeVkGs
	usEo8entGXaQBk4BA4nXn/rAmpkF1CUmzVvEDGHLS2xe85Z5AqPALCQ7ZiEpm4WkbAEj8ypG
	0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Ih9Jr2DcVWDxSFGAQ5GJR7eBebHA4VYE8uKK3MP
	MUpwMCuJ8IaKnAgU4k1JrKxKLcqPLyrNSS0+xJgMDIGJzFKiyfnAZJJXEm9obGJmZGlkbmhh
	ZGxOmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYzeMwxULZYYXz83Z4YRW5Jjcnyv4sbZ
	Upq9X7VqVb4XcDZUp/21U3prufb44iePtym+ZV2ssez2+9Tr9+QmtpVpP8txlJIunrWg/sbh
	+G/b3yUvvlB4K/QSg6DeLKWTk85yf8qKnavyaaUp78OyvTcEXVZp7VJ0kXSqzswqd14fwh58
	vCBoWbUSS3FGoqEWc1FxIgC1HOsqHAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 08:00 PM, Rafael J. Wysocki wrote:
> On Monday, June 24, 2013 04:03:15 PM Viresh Kumar wrote:
>> On 24 June 2013 15:50, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> My impression was that that new interface wouldn't be useful on all platforms
>>> supported by cpufreq.  If that's the case, I'd rather not make changes in the
>>> core code that are needed only to implement that new interface, at least to
>>> start with.
>>
>> Every platform might not have userspace software that would do some
>> actions based on this. But, these are nice and useful stats to have.
>>
>> They tell you a lot about how the hardware/governor/policies are
>> behaving with load. And so will eventually help getting performance based
>> on governor tunables for your platform. That's why I asked to put this in
>> core as this should be pretty much useful.
> 
> OK, let's see how the code will look like.
> 
> Chanwoo, please prepare a v4 with the changes suggested by Viresh.
> 

@Viresh,
I implement v3 patch for load_table debugfs file. As you suggested, v3 pach include
old/new frequency data. But, I don't add additional function to minimize dependency
among cpufreq core functions. And then I use CPUFREQ_LOADCHECK and CPUFREQ_POSTCHANGE
notification to collect cpu data(time, old/new frequency, CPUs load).

Please review v3 patch for load_table debugfs file. Thanks.

Best Regards,
Chanwoo Choi

