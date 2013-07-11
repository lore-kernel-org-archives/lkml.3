Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab3GKDJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 23:09:53 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:58097 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab3GKDJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 23:09:50 -0400
From: Paul Moore <paul@paul-moore.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: linux-next: rebase of lblnet tree
Date: Wed, 10 Jul 2013 23:09:47 -0400
Message-ID: <1571746.n7UVkKkBI4@sifl>
User-Agent: KMail/4.10.5 (Linux/3.9.5-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130711100117.8b042a1a2a494bb9ee0003fd@canb.auug.org.au>
References: <20130711100117.8b042a1a2a494bb9ee0003fd@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 11, 2013 10:01:17 AM Stephen Rothwell wrote:
> Hi Paul,

Hi Stephen,

I know you already emailed me privately about my @hp.com email address, but 
for the sake of everyone else on the list, my @hp.com address no longer works, 
it hasn't for some time now.  Please check my entry in the MAINTAINERS file 
for my correct contact information (this email address).  That said, I 
established this current email address to avoid problems when changing 
employers so hopefully this confusion won't happen again in the future.

> Why have you just rebased the lblnet tree
> (git://git.infradead.org/users/pcmoore/lblnet-2.6_next#master)?  You have
> just invalidated your testing and made it likely that Linus will blast
> you if you ask him to pull your tree.  Your whole tree was already based
> after v3.10 (i.e. released or rebased after the merge window opened), so
> why move it again?

[NOTE: I get the impression that the above is a "form letter" email, but just 
in case ...]

When I added two additional patches to the labeled networking tree today, I 
rebased the tree to verify that there were no merge conflicts and that 
everything worked as expected on a booted system.  I also occasionally rebase 
the tree when there are pending patches and I'm not adding anything new for 
the same reason: I believe that testing changes against the latest upstream 
code is a Good Thing.  If there is a patch with my sign-off in a tree I am 
responsible for, I do my best to make sure it builds, boots, and passes some 
basic sanity tests.  I can't say I'm perfect, but I do try to not push crap 
upwards.

Also, just to be clear, the labeled networking tree usually goes into Linus' 
tree via the netdev or security tree (and then it hits the security tree 
usually via the SELinux tree).  I can't ever think of a time when I asked 
Linus' to pull a tree of mine directly.

If this approach doesn't work for you, please let me know and preferably 
suggest an alternative.

-Paul

-- 
paul moore
www.paul-moore.com

