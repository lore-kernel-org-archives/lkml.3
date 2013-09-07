Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076Ab3IGQ3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 12:29:23 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:41619 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3IGQ3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 12:29:21 -0400
Message-ID: <522B52BA.6030202@gmail.com>
Date: Sat, 07 Sep 2013 18:22:18 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/19] pramfs
References: <522AE04C.6000002@gmail.com> <CAFLxGvw1mJ5GSWMMZhznU0jJn4pvM+jthyLAtKnL_WvGALB6dg@mail.gmail.com>
In-Reply-To: <CAFLxGvw1mJ5GSWMMZhznU0jJn4pvM+jthyLAtKnL_WvGALB6dg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/09/2013 16:58, richard -rw- weinberger ha scritto:
> On Sat, Sep 7, 2013 at 10:14 AM, Marco Stornelli
> <marco.stornelli@gmail.com> wrote:
>> Hi all,
>>
>> this is an attempt to include pramfs in mainline. At the moment pramfs
>> has been included in LTSI kernel. Since last review the code is more
>> or less the same but, with a really big thanks to Vladimir Davydov and
>> Parallels, the development of fsck has been started and we have now
>> the possibility to correct fs errors due to corruption. It's a "young"
>> tool but we are working on it. You can clone the code from our repos:
>>
>> git clone git://git.code.sf.net/p/pramfs/code pramfs-code
>> git clone git://git.code.sf.net/p/pramfs/Tools pramfs-Tools
>
> I'm a bit confused, what kind of non-volatile RAM is your fs targeting?
> Wouldn't it make sense to use pstore like
> arch/powerpc/platforms/pseries/nvram.c does?
>

Usually battery-backed SRAM, but actually it can be used in any piece of 
ram directly accessible and it provides a normal and complete fs 
interface. Usually I do the fs test remapping my system ram. You can 
find documentation here:

http://pramfs.sourceforge.net

Marco
