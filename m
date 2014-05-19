Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaESJ1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:27:07 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:59222 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaESJ1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:27:04 -0400
Message-ID: <5379CE63.1040704@suse.cz>
Date: Mon, 19 May 2014 11:26:59 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        shuah.kh@samsung.com
CC: satoru.takeuchi@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 000/182] 3.12.20-stable review
References: <cover.1399973152.git.jslaby@suse.cz> <53721149.1020902@roeck-us.net>
In-Reply-To: <53721149.1020902@roeck-us.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 02:34 PM, Guenter Roeck wrote:
> On 05/13/2014 02:26 AM, Jiri Slaby wrote:
>> This is the start of the stable review cycle for the 3.12.20 release.
>> There are 182 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu May 15 09:25:52 2014
>> Anything received after that time might be too late.
>>
> 
> Build results:
>     total: 127 pass: 121 skipped: 5 fail: 1
> 
> Qemu tests all passed.
> 
> Results are as expected. The failing build is unicore32:defconfig;
> this is not a concern, it currently fails for all releases.
> 
> Details are available at http://server.roeck-us.net:8010/builders.

On 05/14/2014 04:09 AM, Shuah Khan wrote:
> Compiled and booted on my test system. No dmesg regressions.

Thank you both!

-- 
js
suse labs
