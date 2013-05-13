Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab3EMFOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 01:14:25 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:41558 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab3EMFOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 01:14:24 -0400
To: keescook@chromium.org
Cc: sfr@canb.auug.org.au, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jlayton@redhat.com,
        viro@zeniv.linux.org.uk
Date: Mon, 13 May 2013 01:14:17 -0400 (EDT)
X-Mailer: TouchDown
X-Mailer: Zimbra 8.0.3_GA_5664 (MobileSync - TouchDown(MSRPC)/8.1.00052/)
MIME-Version: 1.0
Subject: =?utf-8?B?UkU6IGxpbnV4LW5leHQ6IG1hbnVhbCBtZXJnZSBvZiB0aGUgYWtwbSB0cmVlIHdpdGggTGludXMn?=
 =?utf-8?B?IHRyZWU=?=
Message-ID: <2046909660.224701.1368422057749.JavaMail.root@zmail12.collab.prod.int.phx2.redhat.com>
Content-Type: multipart/mixed;boundary="__1368422072038TOUCHDOWN_BOUNDARY__"
From: Eric Paris <eparis@redhat.com>
In-Reply-To: <CAGXu5j+bxbXrj-Xf38gekusz2jQNWjLVu1i=Wasqhwowhe3QrA@mail.gmail.com>
References: <20130513120728.f3f469e5d71b39ec78800175@canb.auug.org.au> <1368411070.929.19.camel@localhost> <CAGXu5j+bxbXrj-Xf38gekusz2jQNWjLVu1i=Wasqhwowhe3QrA@mail.gmail.com>
Thread-Topic: linux-next: manual merge of the akpm tree with Linus' tree
Thread-Index: 9LCOedwhJPuLy7yP6bj8kHdHV/Bb1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--__1368422072038TOUCHDOWN_BOUNDARY__
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit




-----Original Message-----
From: Kees Cook [keescook@chromium.org]
Received: Monday, 13 May 2013, 12:49am
To: Eric Paris [eparis@redhat.com]
CC: Stephen Rothwell [sfr@canb.auug.org.au]; Andrew Morton [akpm@linux-foundation.org]; Linus [torvalds@linux-foundation.org]; Linux-Next [linux-next@vger.kernel.org]; LKML [linux-kernel@vger.kernel.org]; Jeff Layton [jlayton@redhat.com]; Al Viro [viro@zeniv.linux.org.uk]
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree


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

--__1368422072038TOUCHDOWN_BOUNDARY__--
