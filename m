Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab3EMQnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 12:43:24 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:48178 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab3EMQnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 12:43:21 -0400
Message-ID: <51911826.907@gmail.com>
Date: Mon, 13 May 2013 09:43:18 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
        Dirk Brandewie <dirk.brandewie@gmail.com>, linux-acpi@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: 3.9.0 + CONFIG_X86_INTEL_PSTATE=y  -> ThinkPad T420 with i5 lost
 ACPI functionality
References: <5183EC09.9080208@gmx.de> <3715884.H8PIhhjRXL@vostro.rjw.lan>
In-Reply-To: <3715884.H8PIhhjRXL@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 12:36 PM, Rafael J. Wysocki wrote:
> On Friday, May 03, 2013 06:55:37 PM Toralf Förster wrote:
>> The following file doesn't exists at my Gentoo Linux
>> /sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load
>> in 3.9.0 if I activate CONFIG_X86_INTEL_PSTATE=y
>>
>> That means, that a command like
>>
>> $> echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load
>>
>> in /etc/rc.local is now no longer working.
>> A high fan +  high temperature are the result, even if just the BOINC client
>> is run with low prio (nice 19) in the back ground.
>>
>> Manually loading the missing module won't work too :
>>
>> $> modprobe acpi_cpufreq
>> modprobe: ERROR: could not insert 'acpi_cpufreq': Device or resource busy
>>
>> Is the behaviour a bug or a feature ?
>
> The thermal management problem is not an intentional outcome, definitely.
>
>> In the later case: How can I achieve the previous behaviour back ?
>>

I spent some more time looking for a solution to this you can get same behavior
by setting a config option in BOINC  "Use at most X % CPU time"
see: http://boinc.berkeley.edu/wiki/Local_preferences


>> This issue might affect the RH EL kernel too [1] where I observed a similar behaviour.
>>
>>
>> [1] http://elrepo.org/bugs/view.php?id=379
>
> Dirk, is this the problem we were talking about recently or something else?
>
> Rafael
>
>

