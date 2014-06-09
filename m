Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934379AbaFIW5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:57:22 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:41309 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934722AbaFIW5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:57:19 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwmajRnDOiBmZQf8rpVE-HigsDYy9oy-TsWLzn-vdyF+Q@mail.gmail.com>
References: <1401332999-15167-1-git-send-email-eparis@redhat.com>
 <20140609223057.GB18475@kroah.com> <CALCETrUD75vSwJUjFuxGCrZ_7DJhCc1KW2v_ndF6EHJ31fUMBg@mail.gmail.com>
 <CA+55aFwmajRnDOiBmZQf8rpVE-HigsDYy9oy-TsWLzn-vdyF+Q@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 9 Jun 2014 15:56:58 -0700
Message-ID: <CALCETrXBSd4qKJE+yVp0YTPdrCDSfGf_SOxaZFgQpULg1bF3aA@mail.gmail.com>
Subject: Re: [PATCH 1/2] auditsc: audit_krule mask accesses need bounds checking
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Eric Paris <eparis@redhat.com>,
        linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 3:53 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jun 9, 2014 at 3:35 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> Hmm.  It seems that it didn't make it into Linus' tree.  Crap.
>
> I assume that if there is a maintainer who normally sends me stuff by
> git, when I see patches in emails they are just informational
> heads-ups about stuff that is being discussed or pending, and that
> I'll see it later in a pull request. So I just ignore them unless I
> have specific comments, since clearly the emailed patch is just
> informational and/or for comments/acks from others.
>
> The exception is unless it *VERY CLEARLY* says otherwise (as in
> "Linus, can you please take this directly due to xyz").
>
> Because why would somebody send me a patch series sometimes, and git
> trees at other times? That would just be stupid.

In this particular case, it's my patch, and I've never sent you a pull
request.  I sort of assumed that security@kernel.org magically caused
acknowledged fixes to end up in your tree.  I'm not sure what I'm
supposed to do here.

Maybe the confusion is because Eric resent the patch?

--Andy
