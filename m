Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbaAZNg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 08:36:56 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751348AbaAZNgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 08:36:55 -0500
Message-ID: <52E50F72.9060300@nod.at>
Date: Sun, 26 Jan 2014 14:36:50 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Harald Arnesen <skogtun.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Panic with latest git kernel
References: <52E50496.3040303@gmail.com> <CAFLxGvx8OQzSzoikh9DT3VF=cdBw4=sU_ZM=BTs=M4Ts84eGgA@mail.gmail.com> <52E50ED7.9070808@gmail.com>
In-Reply-To: <52E50ED7.9070808@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.01.2014 14:34, schrieb Harald Arnesen:
> Richard Weinberger [2014-01-26 14:03]:
> 
>> On Sun, Jan 26, 2014 at 1:50 PM, Harald Arnesen <skogtun.linux@gmail.com> wrote:
>>>> Today I compiled the latest kernel (3.13.0-08526-gb2e448e), and got the
>>>> panic you can see in the attached picture.
>> Are you sure that you initrd is sane?
>> Your /init terminates because the script was unable to find switch_root.
> 
> Well, I haven't changed anything to do with the initrd since I compiled
> the last working kernel (as far as I know, maybe there's a Debian update
> that broke something).

Please make sure that your userspace is sane. :)

> How do I see what's in the initrd? 'file' shows it to be a cpio archive,
> and cpio shows the following contents, both in the working and
> non-working one:
> 
> $ cpio --list </boot/initrd.img-3.13.0-03477-gdf32e43
> kernel
> kernel/x86
> kernel/x86/microcode
> kernel/x86/microcode/GenuineIntel.bin
> 50 blocks
> $

Looks very strange.
Add rdinit=/bin/sh to your commandline such that you get a shell within
the initrd...

Thanks,
//richard
