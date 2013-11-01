Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750928Ab3KAEJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 00:09:11 -0400
Received: from mdfmta004.mxout.tch.inty.net ([91.221.169.45]:45302 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750740Ab3KAEJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 00:09:09 -0400
Message-ID: <52732961.4030501@lougher.demon.co.uk>
Date: Fri, 01 Nov 2013 04:09:05 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Phillip Lougher <phillip@lougher.demon.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the squashfs tree
References: <20131101115723.8faa858bf8a5dadf17d251fb@canb.auug.org.au> <52731AA2.1060800@lougher.demon.co.uk>
In-Reply-To: <52731AA2.1060800@lougher.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-MDF-HostID: 17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/13 03:06, Phillip Lougher wrote:
> On 01/11/13 00:57, Stephen Rothwell wrote:
>> Hi Phillip,
>>
>> After merging the squashfs tree, today's linux-next build (powerpc
>> ppc64_defconfig) failed like this:
>>
>> fs/squashfs/decompressor_single.c: In function 'squashfs_decompressor_create':
>> fs/squashfs/decompressor_single.c:40:2: error: implicit declaration of function 'free' [-Werror=implicit-function-declaration]
>>    free(comp_opts);
>>    ^
>
> Yup, applied and pushed the wrong patch.
>
> I noticed shortly afterwards, and pushed the correct patch, but you
> obviously had already done your pull.
>
> Squashfs: Refactor decompressor interface and code
> committer Phillip Lougher <phillip@squashfs.org.uk> 2013-10-31 23:06:37 (GMT)
>
> These things happen when you rush to get the patches ready for the linux-next
> tree.
>
> Squashfs is spare-time work for me, which means I often have no choice to
> work on it during the night.  Previously when pushing such work for the
> linux-next tree I notice it never gets picked up until the next day, because
> a push at 4 AM is simply too late to get it into the linux-next tree for that
> day because you're in Australia.
>
> So I work out you pull around 11 PM GMT my time, and rush to get the patches
> ready for then.  Screw up and this time around the process is even more
> thankless and humiliating than normal.
>
> Why don't you holier than thou guys get off your pedestals sometime and
> see what it's like for the hobbyists who don't get paid to do the work.
>
> Yeah maybe I'm getting to the point where I considering stopping doing
> this, because it has become utterly thankless.

Apologies.  I was annoyed at myself and let my frustration show.

Phillip

>
> Cheers
>
> Phillip
>
>
>> fs/squashfs/decompressor_single.c:40:2: warning: incompatible implicit declaration of built-in function 'free' [enabled by default]
>>
>> Caused by commit 99d59ddb8a06 ("Squashfs: Refactor decompressor interface
>> and code").
>>
>> I have used the squashfs tree from next-20131031 for today.
>>
>

