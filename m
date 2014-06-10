Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaFJMvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:51:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbaFJMvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:51:03 -0400
Message-ID: <1402404640.4456.4.camel@flatline.rdu.redhat.com>
Subject: Re: [PATCH 1/2] auditsc: audit_krule mask accesses need bounds
 checking
From: Eric Paris <eparis@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Greg KH <gregkh@linuxfoundation.org>, linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Date: Tue, 10 Jun 2014 08:50:40 -0400
In-Reply-To: <CA+55aFxAj5nA-fqTRE0Cotwxywf5LNCb-NnpWCHxZTn2GF3C4g@mail.gmail.com>
References: <1401332999-15167-1-git-send-email-eparis@redhat.com>
	 <20140609223057.GB18475@kroah.com>
	 <CALCETrUD75vSwJUjFuxGCrZ_7DJhCc1KW2v_ndF6EHJ31fUMBg@mail.gmail.com>
	 <CA+55aFwmajRnDOiBmZQf8rpVE-HigsDYy9oy-TsWLzn-vdyF+Q@mail.gmail.com>
	 <CALCETrXBSd4qKJE+yVp0YTPdrCDSfGf_SOxaZFgQpULg1bF3aA@mail.gmail.com>
	 <CA+55aFxAj5nA-fqTRE0Cotwxywf5LNCb-NnpWCHxZTn2GF3C4g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-09 at 16:36 -0700, Linus Torvalds wrote:
> On Mon, Jun 9, 2014 at 3:56 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> >
> > In this particular case, it's my patch, and I've never sent you a pull
> > request.  I sort of assumed that security@kernel.org magically caused
> > acknowledged fixes to end up in your tree.  I'm not sure what I'm
> > supposed to do here.
> >
> > Maybe the confusion is because Eric resent the patch?
> 
> So I saw the patch twice in email , but neither time did I get the
> feeling that I should apply it. The first time Eric responded to it,
> so the maintainer clearly knew about it and was reacting to it, so I
> ignored it. The second time Eric resent it as email to various people
> and lists, and I didn't react to it because I expected that was again
> just for discussion.
> 
> So I'm not blaming you as much as Eric.

No, it's good to blame me.  I was trying to deal with it as fast as I
could since I was already trying to ignore my computer before I got
married last weekend and took the last week off.  I realized when I got
back yesterday you hadn't picked it up and it was on my list of things
to try to handle today.  I think both 1 and 2 are good to be applied to
your tree.  Although only #1 is really an absolutely critical issue.

>  If a maintainer expects me to
> pick it up from the email (rather than his usual git pulls), I want
> that maintainer to *say* so. Because otherwise, as mentioned, I expect
> it to come through the maintainer tree as usual.
> 
>               Linus


