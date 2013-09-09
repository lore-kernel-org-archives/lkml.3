Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab3IISU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:20:56 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:54426 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab3IISUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:20:55 -0400
Message-ID: <522E0FDF.8000108@gmail.com>
Date: Mon, 09 Sep 2013 20:13:51 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/19] pramfs
References: <522AE04C.6000002@gmail.com> <20130908234031.GS12779@dastard>
In-Reply-To: <20130908234031.GS12779@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 09/09/2013 01:40, Dave Chinner ha scritto:
> On Sat, Sep 07, 2013 at 10:14:04AM +0200, Marco Stornelli wrote:
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
> The 1980s are calling, and they want their filesytem back. :)
>
> So, Devil's Advocate time. Convince me as to why pramfs should be
> merged.
>

Never used in my embedded project with more of few mb, and maybe you are 
asking for cases not targeted. Pramfs is in LTSI not why I asked Greg to 
include it, but because there are several companies asked me to do. The 
message wasn't "hey, pramfs is in LTSI, so we must include it in 
mainline" but it was only a consideration and indication that there is 
need of something like that out there. Sure we can talk about if it's 
the best option or not, however this is the real world. In addition, 
this comment is exactly why the kernel community is not really friendly 
to be time-to-market, we have to say it. It's not possible to have a 10 
years review. It's a never ending story. Maybe when there is a big 
company behind a patch the behavior is different and I can do several 
examples, but I don't want to say more, life is hard, I know, even in 
the kernel community. I think I can close the review here, my delusion 
is not for me, I can live well in each case, but for the companies and 
all the people believes in the project.

Thanks to all.

Marco

