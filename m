Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab3EMTZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:25:05 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:64091 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3EMTZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:25:02 -0400
Message-ID: <51913E0A.6060402@gmail.com>
Date: Mon, 13 May 2013 12:24:58 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: 3.9.0 + CONFIG_X86_INTEL_PSTATE=y  -> ThinkPad T420 with i5 lost
 ACPI functionality
References: <5183EC09.9080208@gmx.de> <3715884.H8PIhhjRXL@vostro.rjw.lan> <51911826.907@gmail.com> <519120CC.10403@gmx.de> <51912990.8020206@intel.com> <51913B45.80901@gmx.de>
In-Reply-To: <51913B45.80901@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 12:13 PM, Toralf Förster wrote:
> On 05/13/2013 07:57 PM, Dirk Brandewie wrote:
>>      cd /sys/fs/cgroup/cpu
>>      mkdir bonic
>>      echo 400 > boinc/cpu.shares
>>      boinc &
>>      echo $! > boinc/tasks
>
> In many places of my scripts for automated testing I use currently the
> "nice -n" prefix at my ThinkPad to keep a long battery life, quiet fan,
> cool CPU. The CPU just runs with minimal frequency but will give
> med/max. power on demand.
>
> If the P-State governor will be the replacement the old behaviour -
>
> the kernel menu config says "will become the perferred ... (sic!)
> ...scaling driver for Sandy bridge processors" -
>
> is there a nifty user space tool which replaces "nice" and do all cgroup
> stuff for the user ?
>

cgexec from the libcgroup-tools package (fedora name) look like it will place
a process in a group for you.

https://wiki.archlinux.org/index.php/Cgroups

Has some useful examples.

--Dirk
