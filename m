Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbaEIIc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:32:56 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:32943 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaEIIcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:32:53 -0400
Message-ID: <536C92B0.8030905@suse.cz>
Date: Fri, 09 May 2014 10:32:48 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: shuah.kh@samsung.com, linux@roeck-us.net
CC: stable@vger.kernel.org, satoru.takeuchi@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 00/50] 3.12.19-stable review
References: <cover.1399292849.git.jslaby@suse.cz> <5368F85A.3060307@samsung.com>
In-Reply-To: <5368F85A.3060307@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 04:57 PM, Shuah Khan wrote:
> On 05/05/2014 06:28 AM, Jiri Slaby wrote:
>> This is the start of the stable review cycle for the 3.12.19 release.
>> There are 50 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed May  7 12:27:29 2014
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.19-rc1.xz
>>
>> and the diffstat can be found below.
>>
> 
> Compiled and booted on my test systems. No dmesg regressions.


On 05/05/2014 05:45 PM, Guenter Roeck wrote:> Build results:
> 	total: 127 pass: 121 skipped: 5 fail: 1
>
> qemu tests all passed.
>
> The build failure is for unicore32:defconfig, which fails to build
> on all releases I tried. Results are therefore as expected.
>
> Details are available at http://server.roeck-us.net:8010/builders.

Thank you both!

-- 
js
suse labs
