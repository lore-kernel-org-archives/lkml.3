Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbaDLTia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 15:38:30 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:58684 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaDLTi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 15:38:29 -0400
MIME-Version: 1.0
In-Reply-To: <1397174015.29990.30.camel@localhost>
References: <1397174015.29990.30.camel@localhost>
Date: Sat, 12 Apr 2014 12:38:28 -0700
X-Google-Sender-Auth: BO38doY1frBTpExsiypZOkAYh68
Message-ID: <CA+55aFwX+aXbtGeNUFJF_fpZJroefSY0E63Cx2OyodyGkH1j=A@mail.gmail.com>
Subject: Re: [GIT PULL] Audit subsystem for v3.15
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-audit@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 4:53 PM, Eric Paris <eparis@redhat.com> wrote:
>
> Please pull the audit tree for v3.15.  You will have merge conflicts.

The merge conflicts were easy to resolve. I appreciate you spending
the time to explain them, but quite frankly, I can figure out trivial
ones on my own. What I really really need is to know what the hell the
pull request *does*, and why I should pull this.

So now I've done the merge, and find myself considering just undoing
it again, because there is no explanation for what the hell I pulled
in.

I ended up looking at all the commits and being mightily annoyed by
this all. I guess I'll let it go now, but in general, if I get pull
requests that don't even bother to explain why I should pull and what
the point of it all is, I'm going to start ignoring them.

             Linus
