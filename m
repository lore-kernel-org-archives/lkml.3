Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab3IMW7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 18:59:43 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:14731 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab3IMW7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 18:59:40 -0400
X-AuditID: cbfec37d-b7f0e6d00000657c-1a-523398dabc5e
Message-id: <523398D1.1070106@samsung.com>
Date: Fri, 13 Sep 2013 16:59:29 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/16] 3.11.1-stable review
References: <20130912181156.173326121@linuxfoundation.org>
 <CA+55aFwN78n92A_mnOve0RsBgHh+o_1KOBvn9d+a2gorXEP6QQ@mail.gmail.com>
 <CA+55aFyiR8ugfFsy3dmofD_G+sPkEqYEQbg2wh7hgXnt-H_Uag@mail.gmail.com>
 <20130912182240.GA10404@kroah.com> <20130912182730.GA11890@kroah.com>
In-reply-to: <20130912182730.GA11890@kroah.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9hX91bM4yDDFqO2VjMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJWx6dARloKt/BXv3hxhbGBcxdPFyMkhIWAiMfHsbjYIW0ziwr31QDYXh5DAMkaJjW0X
	GSGcXiaJY5teMoFUCQlsYpRoWaoMYvMKaEkcWfICLM4ioCrx5e1jRhCbTUBd4vPrHewQ9XIS
	TUtWM4PYogIREiuXPGCF6BWU+DH5HguILSJgLNF/dhY7yDJmgT4mie73L8BOEgZa8HjKLxaI
	KyYwSTROvgXWwSmgL7Hswm6wqcwC1hIrJ21jhLDlJTavecsMsVlZ4s/lU0DXcQD9piixfbXV
	BEaRWUh2z0LSPQtJ9wJG5lWMYqXFyQXFSempFSZ6xYm5xaV56XrJ+bmbGCFRU7uD8f5Xm0OM
	AhyMSjy8M72Ng4RYE8uKK3MPMUpwMCuJ8M66axQkxJuSWFmVWpQfX1Sak1p8iJGJg1OqgXHa
	3n9fzD6/ZBScKzWFw8JpxdcF24smbkrisVY01luyob/i5L3ZT27av+qP+2C19bXczJPze05P
	zo+Tvmc/h0laZ7bmAiu3Lbo31hdPyt3dISh/LL84yuLTzuLrZYXvK2bylwq3mUwzLfrcFJzU
	VLJ2StISPbaKWSm/XPUb3p1uV+58spl/7V4lluKMREMt5qLiRADzUPy8eAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 12:27 PM, Greg Kroah-Hartman wrote:
> On Thu, Sep 12, 2013 at 11:22:40AM -0700, Greg Kroah-Hartman wrote:
>> On Thu, Sep 12, 2013 at 11:18:40AM -0700, Linus Torvalds wrote:
>>> On Thu, Sep 12, 2013 at 11:17 AM, Linus Torvalds
>>> <torvalds@linux-foundation.org> wrote:
>>>> Your script may be a bit buggered...
>>>
>>> Or maybe I should take that as a sign that 3.11 is doing really well?
>>>
>>> I'll be optimistic.
>>
>> Hm, something went wrong here, let me track it down...
>
> Ok, that was my fault, was working off of a 'master' branch in a repo
> that expected it to be on the linux-3.11.y branch.  Here's the real
> pseudo-shortlog below.
>
> And it is short for now, as I've been holding off on applying patches
> that are in your tree until 3.12-rc1 comes out.  The patches here are
> ones that people have pointed out to me that should go in specifically
> for various reasons.  So yes, I do think 3.11 is doing really well, I
> have not heard of anything "major" being wrong with it yet.
>
> thanks,
>
> greg k-h
>
>

3.11.1-rc1 applied cleanly to 3.11

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

Cross-compile testing: HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:

Cross-compile tests results:

alpha: defconfig passed
arm: defconfig passed
arm64: defconfig passed
blackfin: defconfig passed
c6x: defconfig passed
mips: defconfig passed
mipsel: defconfig passed
powerpc: wii_defconfig passed
sh: defconfig passed
sparc: defconfig passed
tile: tilegx_defconfig passed

-- Shuah
-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
