Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3EMEtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 00:49:55 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:54166 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3EMEtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 00:49:53 -0400
MIME-Version: 1.0
In-Reply-To: <1368411070.929.19.camel@localhost>
References: <20130513120728.f3f469e5d71b39ec78800175@canb.auug.org.au>
	<1368411070.929.19.camel@localhost>
Date: Sun, 12 May 2013 21:49:53 -0700
X-Google-Sender-Auth: Jy0VuBp5jhXkKxJQR6lIs1vn5f8
Message-ID: <CAGXu5j+bxbXrj-Xf38gekusz2jQNWjLVu1i=Wasqhwowhe3QrA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
From: Kees Cook <keescook@chromium.org>
To: Eric Paris <eparis@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>,
        Linux-Next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jeff Layton <jlayton@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 7:11 PM, Eric Paris <eparis@redhat.com> wrote:
> On Mon, 2013-05-13 at 12:07 +1000, Stephen Rothwell wrote:
>> Hi Andrew,
>>
>> Today's linux-next merge of the akpm tree got a conflict in
>> kernel/auditsc.c between commit b24a30a73054 ("audit: fix event coverage
>> of AUDIT_ANOM_LINK") from Linus' tree and commit "audit: fix mq_open and
>> mq_unlink to add the MQ root as a hidden parent audit_names record" from
>> the akpm tree.
>
> Actually, I've already picked the patch up for 3.11.  So Andrew, you can
> drop it.
>
>> I fixed it up (see below) and can carry the fix as necessary (no action
>> is required).
>>
>> BTW, commit b24a30a73054 from Linus' tree has Eric Paris as Author and
>> Committer, but is only Signed-off-by Kees Cook.  It is part of a long
>> series that did not go anywhere near linus-next.   I do have an audit
>> tree in linux-next
>> (git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit.git#for-next)
>> but that hasn't seen any recent activity.
>
> I thought I sent you a note asking for audit to get pulled into -next
> quite a while back.  I'll resend...
>

Hrm, how did the Author get mangled?

-Kees

--
Kees Cook
Chrome OS Security
