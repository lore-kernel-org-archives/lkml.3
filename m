Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab3CWDHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 23:07:51 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59595 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3CWDHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 23:07:50 -0400
MIME-Version: 1.0
X-Originating-IP: [114.39.109.78]
In-Reply-To: <20130322233540.1c7db7b86afb1a110c2f58e0@canb.auug.org.au>
References: <1363877418.4019.1.camel@phoenix>
	<20130322092736.f379b24f5f3e6a6f0642ef4a@canb.auug.org.au>
	<CAFRkauCd_dL-9muXQz2PV=hBtdfKyzZDqA_5va_Nq37mJcfb5g@mail.gmail.com>
	<20130322233540.1c7db7b86afb1a110c2f58e0@canb.auug.org.au>
Date: Sat, 23 Mar 2013 11:07:49 +0800
Message-ID: <CAFRkauCKVw1ThuHVzw+h_mmcT9Lrvt-ZGUOthCyWeC5Gx=gxpg@mail.gmail.com>
Subject: Re: [linux-next] Not able to fetch next-20130321
From: Axel Lin <axel.lin@ingics.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/22 Stephen Rothwell <sfr@canb.auug.org.au>:
> Hi Axel,
>
> On Fri, 22 Mar 2013 16:51:40 +0800 Axel Lin <axel.lin@ingics.com> wrote:
>>
>> Even with a fresh git clone, it still shows the latest commit is 20130318.
>>
>> $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>>
>> git log shows the latest commit is:
>> commit 0e78c0989334e9c1d578ba25621de14e8441d8b4
>> Author: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date:   Mon Mar 18 16:10:47 2013 +1100
>>
>>     Add linux-next specific files for 20130318
>>
>>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>
> Very weird ... it works for me:
>
> $ git clone --reference linus.git git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git ntest
> Cloning into 'ntest'...
> remote: Counting objects: 192286, done.
> remote: Compressing objects: 100% (34238/34238), done.
> remote: Total 184570 (delta 165819), reused 166851 (delta 149091)
> Receiving objects: 100% (184570/184570), 25.60 MiB | 886 KiB/s, done.
> Resolving deltas: 100% (165819/165819), completed with 5985 local objects.
> Checking out files: 100% (42561/42561), done.
> $ cd ntest
> $ git branch -v
> * master 2db42b7 Add linux-next specific files for 20130322

Hi Stephen,
I figure out this issue now.

For some reason, I have below settings in /etc/hosts
149.20.4.72     git.kernel.org

Now the ip of git.kernel.org is 198.145.20.140.

Sorry for the noise.

Axel
