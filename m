Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbbAXIDV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 03:03:21 -0500
Received: from lists.s-osg.org ([54.187.51.154]:55789 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbbAXIDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 03:03:19 -0500
Date: Sat, 24 Jan 2015 06:03:12 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v3.19-rc6] media fixes
Message-ID: <20150124060312.18b00426@recife.lan>
In-Reply-To: <CA+55aFzpqpczFdNnpFYL0+TA6aT_q=pDUdnGjga6ow2TjxMUmw@mail.gmail.com>
References: <20150123112617.3a592160@recife.lan>
	<CA+55aFzpqpczFdNnpFYL0+TA6aT_q=pDUdnGjga6ow2TjxMUmw@mail.gmail.com>
Organization: Samsung
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Em Sat, 24 Jan 2015 11:11:08 +1200
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> On Sat, Jan 24, 2015 at 1:26 AM, Mauro Carvalho Chehab
> <mchehab@osg.samsung.com> wrote:
> >
> > Please pull from:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media media/v3.19-4
> 
> That does not exist.
> 
> The tip of that linux-media tree does match the commit you claim is
> the tip but that's just the unsigned 'master' branch/. The tag you
> list just doesn't exist at all. There's a v3.19-3, but no 4.

This was due to a bug on my script that creates the tags and push them. 
I fixed it already, and did a git push -t. It should be OK now.
I'll re-send the same pull request, as I think this works best for your
workflow, right?

Regards,
Mauro
