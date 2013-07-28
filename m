Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab3G1IMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 04:12:33 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:39888 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab3G1IM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 04:12:28 -0400
Message-ID: <51F4D18A.7080605@linux.vnet.ibm.com>
Date: Sun, 28 Jul 2013 13:38:42 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: stable 3-10-3: strange output of  "lsmod | grep ^acpi_cpufreq"
References: <51F40612.2050403@gmx.de> <4531734.kTFAPunoch@vostro.rjw.lan> <51F4D17F.1090107@gmx.de>
In-Reply-To: <51F4D17F.1090107@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072808-1396-0000-0000-000003534E05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2013 01:38 PM, Toralf Förster wrote:
> On 07/28/2013 01:39 AM, Rafael J. Wysocki wrote:
>> On Saturday, July 27, 2013 07:40:34 PM Toralf Förster wrote:
>>> it gives at a ThinkPad T420:
>>>
>>> tfoerste@n22 ~/tmp $ lsmod | grep ^acpi_cpufreq
>>> acpi_cpufreq           12902  2147483647
>>
>> That is -1, which indicates some module refcount woes.
>>
>> I definitely can't see that with the mainline on my machines.
> 
> It might be a regression in -stable only, b/c in 3,10.2 I did not
> observed it.
> 
> Srivatsa,
> 
> by any chance - could the revert of the cpufreq patches have something
> to do with that ?
>

Hmmm? Those reverts didn't touch anything related to module
refcounts.. So I don't think they have anything to do with this.

Also, is the issue related to suspend/resume at all? (Sorry, I don't
have your original email, so I'm not sure what the exact issue is).

 
Regards,
Srivatsa S. Bhat

