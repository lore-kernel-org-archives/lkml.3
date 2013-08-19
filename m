Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab3HSVJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:09:03 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:42379 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3HSVJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:09:00 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20130819205736.GA13964@titan.lakedaemon.net>
References: <20130819160537.1eeb0a9ebc269def138e016b@canb.auug.org.au>
	<20130819205736.GA13964@titan.lakedaemon.net>
Date: Mon, 19 Aug 2013 14:09:00 -0700
Message-ID: <CAOesGMhRo1X=w=2-pKNz-eXiviWg3aqtVyW=f43RfigTS4dRmg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the mvebu tree with the arm-soc tree
From: Olof Johansson <olof@lixom.net>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it's this commit:

commit 89602312c5755c87a5ca6ba8ef6b0fce9d510951
Merge: a0cec78 f23afe2
Author:     Jason Cooper <jason@lakedaemon.net>
AuthorDate: Wed Aug 14 18:55:13 2013 +0000
Commit:     Jason Cooper <jason@lakedaemon.net>
CommitDate: Wed Aug 14 18:55:13 2013 +0000

    Merge remote-tracking branch 'arm-soc/for-next' into mvebu/drivers



You merged back the for-next branch from arm-soc into your tree. Big no-no.


This brings up the subject of subplatform trees and conflicts and
-next. I wonder if we should ask Stephen to put all these trees in a
category where if they have any substantial conflicts or weirdness
like this, that he just drops it for the current -next build instead
of spending effort on them.

That would give us on arm-soc a chance to sort out things and even
rebase patches if needed without causing a lot of extra work for sfr.


-Olof


On Mon, Aug 19, 2013 at 1:57 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> Hi Stephen,
>
> On Mon, Aug 19, 2013 at 04:05:37PM +1000, Stephen Rothwell wrote:
>> Today's linux-next merge of the mvebu tree got conflicts in various files
>> between merges and commits in the arm-soc tree and merges in the mvebu
>> tree.
>
> I'm afraid I'm a bit lost...
>
>> These merges/commits in the mvebu tree appear to be from a previous
>> version of the arm-soc tree that the mvebu tree has been rebased upon.
>> Please don't do that - the arm-soc tree as a whole is not stable.
>
> I didn't do anything different from the other times I built for-next.
> Could you give me a specific example when you build linux-next again?
> I'll certainly try to avoid it in the future, but it'll be easier if I
> know what 'it' is. ;-)
>
> I'll not change for-next today, and we'll see how it goes.
>
> thx,
>
> Jason.
