Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763523Ab3ECVnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 17:43:16 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:56843 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760475Ab3ECVnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 17:43:14 -0400
Message-ID: <51842F6F.1050005@intel.com>
Date: Fri, 03 May 2013 14:43:11 -0700
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
References: <5183EC09.9080208@gmx.de> <3715884.H8PIhhjRXL@vostro.rjw.lan> <518427D4.3050104@gmail.com> <51842B79.8060302@gmx.de>
In-Reply-To: <51842B79.8060302@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 02:26 PM, Toralf Förster wrote:
> On 05/03/2013 11:10 PM, Dirk Brandewie wrote:
>>
>> ignore_nice_load is a feature of the ondemand governor.
>> The intel_pstate driver is seeing the load presented by the BOINC client
>> and is adjusting the pstate accordingly.
>
> Is the intel_pstate driver a choice for a notebook and friends where a
> grid software is running as a low-prio back ground job ?
>

Probably not.

> Because the CPU will be running mostly at high(er) frequency - which
> always results in a high temperature and short battery time.
>

It would be better IMHO if the client software limited the resources
it uses when the system is not on wall power but that is a seperate
discussion :-)

--Dirk

