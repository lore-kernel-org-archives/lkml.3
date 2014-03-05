Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaCEI2C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 03:28:02 -0500
Received: from mx01-fr.bfs.de ([193.174.231.67]:18428 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbaCEI2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 03:28:00 -0500
Message-ID: <5316E00A.3030704@bfs.de>
Date: Wed, 05 Mar 2014 09:27:54 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: "kernelnewbies@kernelnewbies.org" <kernelnewbies@kernelnewbies.org>,
        kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: My Kernel bug is celebrating 2 years. Can you help me fix it?
References: <CA+MoWDrTNtAHKsiBHz=W4=eJRO=m9EK_HZ7zLxb=4fg5riUQeg@mail.gmail.com>
In-Reply-To: <CA+MoWDrTNtAHKsiBHz=W4=eJRO=m9EK_HZ7zLxb=4fg5riUQeg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 04.03.2014 22:26, schrieb Peter Senna Tschudin:
> I have reported a bug more than two years ago and it is still
> affecting me. The bug report gives some information:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=787299
> 
> I have tried basic debug instructions from:
> https://www.kernel.org/doc/Documentation/power/basic-pm-debugging.txt
> 
> And everything works as expected when:
> # echo freeze > /sys/power/state
> # echo disk > /sys/power/state
> 
> I have asked for help for fixing it:
> https://lkml.org/lkml/2013/11/1/186
> 
> But I don't have a serial port. How can I debug this issue without a
> "real" serial port? Or what else can I try? 
You need to create a kernel with networksupport,
setup "netconsole" you need a second computer to receive the issues.


>How can I explore the hint
> about the problem only happening with VT-d enabled in BIOS? How can I
> explore the hint about the problem not happening if the option
> nox2apic is passed to the Kernel?

never heard about that until now, obviously there is a bug in several
acpi's that can be triggered. If your systems works with nox2apic
as bootparameter you should be happy since a workaround is available.
Information about it is used can be find here:
http://lxr.free-electrons.com/ident?a=microblaze;i=nox2apic

re,
 wh


> Thank you,
> 
> Peter
> 
> P.S Yes, it works on Windows.
> 
