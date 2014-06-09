Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343AbaFIXg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:36:57 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:46733 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbaFIXgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 19:36:55 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXBSd4qKJE+yVp0YTPdrCDSfGf_SOxaZFgQpULg1bF3aA@mail.gmail.com>
References: <1401332999-15167-1-git-send-email-eparis@redhat.com>
	<20140609223057.GB18475@kroah.com>
	<CALCETrUD75vSwJUjFuxGCrZ_7DJhCc1KW2v_ndF6EHJ31fUMBg@mail.gmail.com>
	<CA+55aFwmajRnDOiBmZQf8rpVE-HigsDYy9oy-TsWLzn-vdyF+Q@mail.gmail.com>
	<CALCETrXBSd4qKJE+yVp0YTPdrCDSfGf_SOxaZFgQpULg1bF3aA@mail.gmail.com>
Date: Mon, 9 Jun 2014 16:36:54 -0700
X-Google-Sender-Auth: oB5HoVUqhaC8tKCT8KGt7k1z30o
Message-ID: <CA+55aFxAj5nA-fqTRE0Cotwxywf5LNCb-NnpWCHxZTn2GF3C4g@mail.gmail.com>
Subject: Re: [PATCH 1/2] auditsc: audit_krule mask accesses need bounds checking
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Greg KH <gregkh@linuxfoundation.org>, Eric Paris <eparis@redhat.com>,
        linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 3:56 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> In this particular case, it's my patch, and I've never sent you a pull
> request.  I sort of assumed that security@kernel.org magically caused
> acknowledged fixes to end up in your tree.  I'm not sure what I'm
> supposed to do here.
>
> Maybe the confusion is because Eric resent the patch?

So I saw the patch twice in email , but neither time did I get the
feeling that I should apply it. The first time Eric responded to it,
so the maintainer clearly knew about it and was reacting to it, so I
ignored it. The second time Eric resent it as email to various people
and lists, and I didn't react to it because I expected that was again
just for discussion.

So I'm not blaming you as much as Eric. If a maintainer expects me to
pick it up from the email (rather than his usual git pulls), I want
that maintainer to *say* so. Because otherwise, as mentioned, I expect
it to come through the maintainer tree as usual.

              Linus
