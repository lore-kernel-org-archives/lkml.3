Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbaAZNls (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 08:41:48 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:43647 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaAZNlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 08:41:47 -0500
Message-ID: <52E51099.2070808@gmail.com>
Date: Sun, 26 Jan 2014 14:41:45 +0100
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
>> > kernel
>> > kernel/x86
>> > kernel/x86/microcode
>> > kernel/x86/microcode/GenuineIntel.bin
>> > 50 blocks
>> > $
> Looks very strange.

The same with the Debian-provided kernel/initrd 3.12-1-amd64

> Add rdinit=/bin/sh to your commandline such that you get a shell within
> the initrd...

Will do.
-- 
Hilsen Harald
