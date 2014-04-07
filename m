Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbaDGJcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 05:32:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024AbaDGJcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 05:32:03 -0400
Message-ID: <1396863114.3770.7.camel@menhir>
Subject: Re: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cluster-devel@redhat.com
Date: Mon, 07 Apr 2014 10:31:54 +0100
In-Reply-To: <CA+55aFymkWynOvTurAy5savDSPXWL7AkS=5ax7HE_h3O0phwXw@mail.gmail.com>
References: <1396394127.5088.0.camel@menhir>
	 <CA+55aFymkWynOvTurAy5savDSPXWL7AkS=5ax7HE_h3O0phwXw@mail.gmail.com>
Organization: Red Hat UK Ltd
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2014-04-04 at 14:52 -0700, Linus Torvalds wrote:
> On Tue, Apr 1, 2014 at 4:15 PM, Steven Whitehouse <swhiteho@redhat.com> wrote:
> >
> > Please consider pulling the following changes
> 
> This pull request is also missing shortlog and diffstat, like Jeff
> Layton's did. Did we have some tooling failure, or is it just
> coincidence?
> 
> Please, guys, make sure your pull requests are valid. I've pulled this
> one too, but..
> 
>                Linus

Sorry for the delay. I'd just been travelling for a few days and I
didn't have remote access to the box I used to generated the pull
request. Now that I've been able to have a look at the bash history, I
can see what has happened....

git request-pull gfs2-merge-window git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw.git >my.pull

What what I'd used to generate the request. Which is incorrect in that
it should have been:

git request-pull master git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw.git gfs2-merge-window >my.pull

but it seems by putting the arguments in the wrong order, I still got a
pull request generated, but without the diffstat, which is probably why
I didn't spot my mistake.

Anyway, apologies for having messed this up - I'll make a note to check
this in future,

Steve


