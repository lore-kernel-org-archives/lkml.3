Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaKEINh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:13:37 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49464 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaKEINf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:13:35 -0500
Message-ID: <5459DC2C.4030707@suse.cz>
Date: Wed, 05 Nov 2014 09:13:32 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, shuah.kh@samsung.com
CC: stable@vger.kernel.org, satoru.takeuchi@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 000/144] 3.12.32-stable review
References: <cover.1414759455.git.jslaby@suse.cz> <20141031165016.GA7958@roeck-us.net>
In-Reply-To: <20141031165016.GA7958@roeck-us.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2014, 05:50 PM, Guenter Roeck wrote:
> On Fri, Oct 31, 2014 at 02:14:07PM +0100, Jiri Slaby wrote:
>> This is the start of the stable review cycle for the 3.12.32 release.
>> There are 144 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Tue Nov  4 13:44:15 CET 2014.
>> Anything received after that time might be too late.
>>
> Build results:
> 	total: 135 pass: 135 fail: 0
> Qemu test results:
> 	total: 27 pass: 27 fail: 0
> 
> This is with v3.12.31-145-g6eb2b7e.

On 11/03/2014, 08:15 PM, Shuah Khan wrote:
> Compiled and booted on my test systems. No dmesg regressions.

Thank you both!

-- 
js
suse labs
