Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763323Ab3IEHZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 03:25:50 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:18330 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301Ab3IEHZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 03:25:48 -0400
Date: Thu, 5 Sep 2013 09:25:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: rebase of the jdelvare-hwmon quilt series
Message-ID: <20130905092536.44dbe86a@endymion.delvare>
In-Reply-To: <20130905101903.0198dbbfdf9e9172fb9b55b2@canb.auug.org.au>
References: <20130905101903.0198dbbfdf9e9172fb9b55b2@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, 5 Sep 2013 10:19:03 +1000, Stephen Rothwell wrote:
> Why did you bother rebasing the jdelvare-hwmon quilt series?  None of the
> patches changed (not that that even matters).

I'm not "rebasing". Rebasing is a git thing, and I'm using quilt, not
git, to feed linux-next. Until the patches hit Linus' tree, I am not
maintaining a tree, I am maintaining a patch set on top of a moving
tree. I only use git to send my pull request to Linus to make things
easier for him.

What you see is just how quilt works. That's nothing to worry about.
I've been working that way for over 6 years. I am curious why you
started yelling at me about this 3 months ago when it has proven to
work just fine for 6 years. You asked me to tag what my quilt series
was based on, and I did. You asked me to get my patches in linux-next
ASAP so that they get more testing, and I do.

Last time, you mentioned a problem with testing results being lost when
I "rebase" my quilt series". I don't quite think it's true for hwmon
patches as the subsystem is pretty much self-contained (the things I am
working on at least) plus I do built-test and to some extent run-test
the patches continuously, so I am confident my approach isn't breaking
bisectability.

But I have heard you nevertheless and already slightly changed my
process. I will no longer be "rebasing" during the merge window, i.e.
the first pull request I send during the merge window, which contains
the patches that have been waiting or have been added since the
previous merge window, will now be based on the just-released .0
kernel, rather than the current pre-rc1 state of Linus' tree at the
time I issue the pull request. Hopefully this should address your "test
results are lost" concern.

I don't think there's much more I can offer. I have to work with a
relatively recent tree so I have to "rebase" from times to times
anyway. At least once per development cycle, right? And I don't think
it would be very reasonable to stay on -rc1 all the time. That's why I
follow upstream development between -rc1 and final, and will only stop
doing so between final and -rc1. Staying with .0 wouldn't be reasonable
either, there's a reason why we maintain stable kernels trees. I don't
think you want developers to base their work on the previous stable
kernel, right?

You see, I don't want to make your life harder or anything. It's just
that your request doesn't make sense to me. "Don't rebase" is not
something I can do much with, as I do have to follow upstream
development and rebase at some point in time anyway. If you propose a
complete workflow which is better than what I do today, I'll be happy
to consider switching to it. But just telling me to skip one mandatory
step in my current workflow is simply not helping, sorry.

-- 
Jean Delvare
