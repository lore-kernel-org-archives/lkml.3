Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965179AbaGES0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 14:26:44 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55406 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049AbaGES0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 14:26:42 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53B84361.5050400@roeck-us.net>
Date: Sat, 05 Jul 2014 11:26:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/19] 3.4.97-stable review
References: <20140704221436.423715636@linuxfoundation.org> <53B78F75.6080206@roeck-us.net> <20140705174646.GA17206@kroah.com> <20140705174847.GA3325@kroah.com>
In-Reply-To: <20140705174847.GA3325@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2014 10:48 AM, Greg Kroah-Hartman wrote:
> On Sat, Jul 05, 2014 at 10:46:46AM -0700, Greg Kroah-Hartman wrote:
>> On Fri, Jul 04, 2014 at 10:39:01PM -0700, Guenter Roeck wrote:
>>> On 07/04/2014 03:15 PM, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 3.4.97 release.
>>>> There are 19 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Sun Jul  6 22:14:29 UTC 2014.
>>>> Anything received after that time might be too late.
>>>>
>>>
>>> Build results:
>>> 	total: 137 pass: 111 skipped: 20 fail: 6
>>
>> 111 skipped?  Did you add a bunch more targets?  Why skip them?
>
> Doh, that is 20 skipped, nevermind...
>
> But, in looking at your site, it seems that there are always at least 7
> that are "skipped", for all kernel versions.  Why?
>

lowest 'skipped' value is actually 4, for 3.14.

'skipped' means that a configuration does not apply for this kernel version.
As I am adding more recent configurations, the number of 'skipped' builds
gets larger for older kernels. Similar, as configurations are dropped
from newer kernels, the number gets larger for newer kernels as well.

I'll see if I can change the output and not display the 'skipped' value
in the final summary; it doesn't really provide value and just creates
confusion.

Guenter

