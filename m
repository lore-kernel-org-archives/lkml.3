Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161564Ab3DENdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 09:33:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49838 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161177Ab3DENc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 09:32:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Subject: Re: linux-next: manual merge of the arm-soc tree with the xilinx tree
Date: Fri, 5 Apr 2013 15:32:45 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        John Linn <John.Linn@xilinx.com>
References: <20130405153335.baf29606a97b1bee415f3546@canb.auug.org.au> <201304051409.37708.arnd@arndb.de> <CAHTX3d+PZ=G6JYBo7Hvqe=G77udaCFJ4pD4z_sQw_FDGP-xt=A@mail.gmail.com>
In-Reply-To: <CAHTX3d+PZ=G6JYBo7Hvqe=G77udaCFJ4pD4z_sQw_FDGP-xt=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304051532.46156.arnd@arndb.de>
X-Provags-ID: V02:K0:V0DIFr9YAtYbymqVPFTwpTRWRFtKuK6MSOaU+WLGly8
 kmz2aONSj72eJntoackHfkfXkX/wvxaBm4ColurVkfRk7bp6YR
 WAHGiqlSyv2Zp5yIz6wkMYYlcebKaglEnxNIoW9VwV4zh7d/jP
 b603xBLUMh515VZVp+YeonMFUok5JI2KmhB94uCCJdpScWyg0d
 kADh0b5ZFqR5scoNDeBUrgSQ1H0quwg/1kO5RYwW/K7L9SjQzT
 mL0T9hinhobygNb+q2tG65vQEkD7fMoa4BRplwf6fm2oJU4Mk1
 YuJxcS/s16XRluc9DSsPc5KvxnFyMzc8SSAr2eIZ3sqdNYIaMb
 gXxBslvSGZ+nJoOAixUM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 April 2013, Michal Simek wrote:
> > > Interesting. I rebased my arm-next branch based on 3.9-rc5
> > > with some Rob's + one Arnd patch from arm-soc - clksrc/cleanup branch.
> > >
> > > I will fix my arm-next branch.
> >
> > The for-next branch in arm-soc is not stable, you should never base
> > anything on it. If you depend on some stable branch, that is in arm-soc,
> > then use just that branch, not one of the next/* branches or for-next.
> >
> 
> I haven't based on arm-soc for-next branch my arm-next branch.
> I just took all patches I need for zynq and done git rebase v3.5-rc5.
> Which caused that I have became commuter of that 4 patches
> and there is probably any conflict between your for-next branch and
> clksrc/cleanup
> which you have resolved in for-next branch.

Ah, I see. That was actually my fault, I'm sorry for causing trouble
here and then accusing you instead.

> And because of my rebase sha1 are different that's why Stephen
> had problem with it.
> I have changed my arm-next branch and will see on Monday if Stephen
> will report any problem or not.

Ok, thanks!

	Arnd
