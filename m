Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaAZOrO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 09:47:14 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:42567 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaAZOrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 09:47:13 -0500
Message-ID: <52E51FEE.4020403@gmail.com>
Date: Sun, 26 Jan 2014 15:47:10 +0100
From: Harald Arnesen <skogtun.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Panic with latest git kernel
References: <52E50496.3040303@gmail.com> <CAFLxGvx8OQzSzoikh9DT3VF=cdBw4=sU_ZM=BTs=M4Ts84eGgA@mail.gmail.com> <52E50ED7.9070808@gmail.com> <52E50F72.9060300@nod.at>
In-Reply-To: <52E50F72.9060300@nod.at>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger [2014-01-26 14:36]:

>> $ cpio --list </boot/initrd.img-3.13.0-03477-gdf32e43
>> kernel
>> kernel/x86
>> kernel/x86/microcode
>> kernel/x86/microcode/GenuineIntel.bin
>> 50 blocks
>> $

> Looks very strange.
> Add rdinit=/bin/sh to your commandline such that you get a shell within
> the initrd...

Okay, I did. On the non-working kernel/initrd, the working ditto, and
the Debian-provided files. And ls shows contents that seem sane.

None of the initrds have a switch_root in them, neither in /sbin or
anywhere else. They all have a /bin/pivot_root, which may be the same?
-- 
Hilsen Harald
