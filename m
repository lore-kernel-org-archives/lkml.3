Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbaEDX77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 19:59:59 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:45444 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbaEDX76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 19:59:58 -0400
Message-ID: <1399247989.2485.6.camel@wisdom>
Subject: Re: [PATCH v2 2/2] staging/rtl8192e: userspace ptr deref +
 incorrect declarations
From: Dominique van den Broeck <domdevlin@free.fr>
Reply-To: domdevlin@free.fr
To: Levente Kurusa <levex@linux.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 05 May 2014 01:59:49 +0200
In-Reply-To: <20140504174823.GA26361@linux.com>
References: <1399214787-15675-1-git-send-email-domdevlin@free.fr>
	 <20140504174823.GA26361@linux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Good evening,

Forgive my mistakes, I sent only a few patches yet and I'm still learning.
Nevertheless:

> What is that period in the commit message? And the semicolon?

Semicolons is what one use to ponctuate an enumerated list (at least
in french). In fact, it was their primary use before computer era.

Is there something wrong with it ? I check all my patches with
checkpatch.pl --strict before sending them and it didn't seem to
complain...

> You should also be a bit more specific. Also, the Subject line is
> very bad. Better go with something like this:
> 
> staging: rtl8192e: fix userspace pointer dereference

Right. I used the slash as a subpart of the tree. Didn't know what
was the best for this situation.

> And when you resend a patchset, please resend the full patchset.

I usually do but I've got an acceptation message for the first one
(see below).

> This is totally unneccessary.

Should at least have gone in the body below indeed.

> When you cite a commit please don't include the full hash, that is
> non informational. Better put the first 7 characters of the hash and
> the first line of the commit message as well in parantheses, like so:
>
> 5169af2 ("Staging: rtl8192e: Fix declaration of symbols")
> (I even have a command for this in vim :-) )

I'm interested. I use vim too.

> Are you sure that 1/2 was applied to the staging tree?
> It's unlikely that 1/2 is applied while 2/2 is left alone.

As stated before, I received the common automatic mail from
Greg KH regarding this one. So I'll now wait before I do a v3
for this issue. If so, I'll resent the complete set if required.

> Oh, I am unable to find commit b5c8d48 in Linus' or staging-next.
> In which tree is it?

It's linux-next. If I quote a commit, I should the tree as well,
indeed. But since the v1 was performed partially for the Eudyptula
Project and since it was a response to a modification request, 
I though it was implicit.

> Could you please as well remove that empty line in the declarations?

I'll do.
Cheers.



