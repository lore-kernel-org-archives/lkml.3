Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaBUCth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:49:37 -0500
Received: from mail.active-venture.com ([67.228.131.205]:65038 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaBUCtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:49:35 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <5306BEBD.1040906@roeck-us.net>
Date: Thu, 20 Feb 2014 18:49:33 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.13 00/40] 3.13.4-stable review
References: <20140218224433.337299968@linuxfoundation.org> <20140219043026.GA15371@roeck-us.net> <20140220183220.GD15290@kroah.com> <20140220232332.GA3584@roeck-us.net> <20140220233201.GA6349@kroah.com>
In-Reply-To: <20140220233201.GA6349@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 03:32 PM, Greg Kroah-Hartman wrote:
> On Thu, Feb 20, 2014 at 03:23:32PM -0800, Guenter Roeck wrote:
>> On Thu, Feb 20, 2014 at 10:32:20AM -0800, Greg Kroah-Hartman wrote:
>>> On Tue, Feb 18, 2014 at 08:30:26PM -0800, Guenter Roeck wrote:
>>>> On Tue, Feb 18, 2014 at 02:47:01PM -0800, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 3.13.4 release.
>>>>> There are 40 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Thu Feb 20 22:44:22 UTC 2014.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>
>>>> Build results:
>>>>      total: 126 pass: 122 skipped: 4 fail: 0
>>>>
>>>> qemu tests all passed.
>>>>
>>>> Details are available at http://server.roeck-us.net:8010/builders.
>>>>
>>>> Results are as expected.
>>>
>>> Thanks for testing and letting me know.  Interesting that the pstate
>>> buggy patch didn't hit your build system testing...
>>>
>> Nothing is perfect :-(. You mean the one where your builder
>> takes much more time to build the kernel with the patch applied,
>> or was here another one ?
>
> That same patch caused a bunch of boot-time failures on some systems.
> But not all of them, I think it depended on the hardware present.
>

My tests are not sophisticated enough to catch that kind of problem,
sorry. I am more surprised that Fenguang's test robot didn't find it;
that thing seems to catch pretty much everything nowadays.

Guenter


