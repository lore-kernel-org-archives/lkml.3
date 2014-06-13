Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaFMQS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:18:28 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60878 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaFMQS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:18:27 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <539B244B.7060000@roeck-us.net>
Date: Fri, 13 Jun 2014 09:18:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.15 00/12] 3.15.1-stable review
References: <20140612232044.886466924@linuxfoundation.org> <539B15B2.9080205@roeck-us.net> <20140613160749.GA18210@kroah.com>
In-Reply-To: <20140613160749.GA18210@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 09:07 AM, Greg Kroah-Hartman wrote:
> On Fri, Jun 13, 2014 at 08:16:02AM -0700, Guenter Roeck wrote:
>> On 06/12/2014 04:21 PM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 3.15.1 release.
>>> There are 12 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat Jun 14 23:20:28 UTC 2014.
>>> Anything received after that time might be too late.
>>>
>>
>> Build results:
>> 	total: 143 pass: 135 skipped: 5 fail: 3
>> Failed builds:
>> 	powerpc:allmodconfig (binutils 2.23)
>> 	powerpc:allmodconfig (binutils 2.24)
>> 	unicore32:defconfig
>
> Are these powerpc build failures to be expected?  I'm guessing that
> unicore32 just never has built properly, right?
>

For powerpc, yes. Ben is working on a patch to fix the problem, which turns out
to be tricky.

unicore32 - correct, it doesn't build at least since 3.0. The maintainer submitted
a set of patches to Linus to fix the problem a couple of weeks ago, but for some
reason Linus doesn't accept it. I guess it will be up to Linus and the unicore
maintainer to decide the fate of the architecture. I don't want to drop the build;
this way people are and will be painfully aware that there is an architecture which
did not build for at least 15 releases.

[ Not that score is any better, really, but I have no means to build it. ]

Guenter

