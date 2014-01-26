Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaAZPAU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 10:00:20 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751444AbaAZPAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 10:00:19 -0500
Message-ID: <52E52300.7020008@nod.at>
Date: Sun, 26 Jan 2014 16:00:16 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Harald Arnesen <skogtun.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Panic with latest git kernel
References: <52E50496.3040303@gmail.com> <CAFLxGvx8OQzSzoikh9DT3VF=cdBw4=sU_ZM=BTs=M4Ts84eGgA@mail.gmail.com> <52E50ED7.9070808@gmail.com> <52E50F72.9060300@nod.at> <52E51FEE.4020403@gmail.com>
In-Reply-To: <52E51FEE.4020403@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.01.2014 15:47, schrieb Harald Arnesen:
> Richard Weinberger [2014-01-26 14:36]:
> 
>>> $ cpio --list </boot/initrd.img-3.13.0-03477-gdf32e43
>>> kernel
>>> kernel/x86
>>> kernel/x86/microcode
>>> kernel/x86/microcode/GenuineIntel.bin
>>> 50 blocks
>>> $
> 
>> Looks very strange.
>> Add rdinit=/bin/sh to your commandline such that you get a shell within
>> the initrd...
> 
> Okay, I did. On the non-working kernel/initrd, the working ditto, and
> the Debian-provided files. And ls shows contents that seem sane.
> 
> None of the initrds have a switch_root in them, neither in /sbin or
> anywhere else. They all have a /bin/pivot_root, which may be the same?

Your image shows that the kernel looses the init process because /init seems
to be unable to exec switch_root.
Find out what is going on in your initrd.

So far it has zero to do with the kernel itself.

Thanks,
//richard
