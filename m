Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbbALXMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:12:01 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:41871 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbbALXL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:11:58 -0500
Message-ID: <54B454B8.4000202@gmail.com>
Date: Mon, 12 Jan 2015 15:11:52 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Gregory Fong <gregory.0xf0@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: brcmstb: update CPU power management sequence
References: <1418786030-23455-1-git-send-email-computersforpeace@gmail.com> <CADtm3G5ZaOsJ_pvY2ho0yYhbhbqtCwsPZfnEc0rwhCBC1ho16g@mail.gmail.com>
In-Reply-To: <CADtm3G5ZaOsJ_pvY2ho0yYhbhbqtCwsPZfnEc0rwhCBC1ho16g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/12/14 15:25, Gregory Fong wrote:
> On Tue, Dec 16, 2014 at 7:13 PM, Brian Norris
> <computersforpeace@gmail.com> wrote:
>> The automatic CPU power state machine for B15 CPUs does not work
>> reliably as-is. This patch implements a manual sequence in software to
>> replace it.
>>
>> This was tested successfully with over 10,000 hotplug cycles of
>> something like this:
>>
>>   echo 0 > /sys/devices/system/cpu/cpu1/online
>>   echo 1 > /sys/devices/system/cpu/cpu1/online
>>
>> whereas the existing sequence often locks up after a few hundred cycles.
>>
>> Fixes: 62639c2f5332 ("ARM: brcmstb: reintroduce SMP support")
>> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> 
> Acked-by: Gregory Fong <gregory.0xf0@gmail.com>
> 

Applied, and queued up for 3.20, thanks!
-- 
Florian
