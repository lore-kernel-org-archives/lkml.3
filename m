Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3CVIvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 04:51:44 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:50488 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3CVIvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 04:51:41 -0400
MIME-Version: 1.0
X-Originating-IP: [114.39.107.32]
In-Reply-To: <20130322092736.f379b24f5f3e6a6f0642ef4a@canb.auug.org.au>
References: <1363877418.4019.1.camel@phoenix>
	<20130322092736.f379b24f5f3e6a6f0642ef4a@canb.auug.org.au>
Date: Fri, 22 Mar 2013 16:51:40 +0800
Message-ID: <CAFRkauCd_dL-9muXQz2PV=hBtdfKyzZDqA_5va_Nq37mJcfb5g@mail.gmail.com>
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
> On Thu, 21 Mar 2013 22:50:18 +0800 Axel Lin <axel.lin@ingics.com> wrote:
>>
>> I run "git remote update" but cannot find next-20130321 tag.
>> It seems the latest tag is "next-20130318".
>> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/
>
> It seems to have come good by the time I had a look.  And I am pretty
> sure that people had downloaded next-20130320 ok.

Even with a fresh git clone, it still shows the latest commit is 20130318.

$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

git log shows the latest commit is:
commit 0e78c0989334e9c1d578ba25621de14e8441d8b4
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Mon Mar 18 16:10:47 2013 +1100

    Add linux-next specific files for 20130318

    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
