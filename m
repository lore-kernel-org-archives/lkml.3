Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934393AbaLKJ5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 04:57:12 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:44822 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933221AbaLKJ5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 04:57:09 -0500
Message-ID: <54896A71.2030302@suse.cz>
Date: Thu, 11 Dec 2014 10:57:05 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        shuah.kh@samsung.com
CC: satoru.takeuchi@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 00/66] 3.12.35-stable review
References: <cover.1417878427.git.jslaby@suse.cz> <54839AA6.7060502@roeck-us.net>
In-Reply-To: <54839AA6.7060502@roeck-us.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2014, 01:09 AM, Guenter Roeck wrote:
> On 12/06/2014 07:07 AM, Jiri Slaby wrote:
>> This is the start of the stable review cycle for the 3.12.35 release.
>> There are 66 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed Dec 10 16:07:07 CET 2014.
>> Anything received after that time might be too late.
>>
> 
> Build results:
>     total: 135 pass: 135 fail: 0
> Qemu tests:
>     total: 27 pass: 27 fail: 0
> 
> Details are available at http://server.roeck-us.net:8010/builders.


On 12/08/2014, 06:04 PM, Shuah Khan wrote:
> Compiled and booted on my test system. No dmesg regressions.

Thank you both!

-- 
js
suse labs
