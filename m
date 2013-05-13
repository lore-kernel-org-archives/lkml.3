Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab3EMFUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 01:20:22 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:42001 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab3EMFUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 01:20:21 -0400
To: keescook@chromium.org
Cc: sfr@canb.auug.org.au, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jlayton@redhat.com,
        viro@zeniv.linux.org.uk
Date: Mon, 13 May 2013 01:20:16 -0400 (EDT)
X-Mailer: TouchDown
X-Mailer: Zimbra 8.0.3_GA_5664 (MobileSync - TouchDown(MSRPC)/8.1.00052/)
MIME-Version: 1.0
Subject: =?utf-8?B?UkU6IGxpbnV4LW5leHQ6IG1hbnVhbCBtZXJnZSBvZiB0aGUgYWtwbSB0cmVlIHdpdGggTGludXMn?=
 =?utf-8?B?IHRyZWU=?=
Content-Type: multipart/mixed;boundary="__1368422429899TOUCHDOWN_BOUNDARY__"
Message-ID: <341438329.225168.1368422416510.JavaMail.root@zmail12.collab.prod.int.phx2.redhat.com>
From: Eric Paris <eparis@redhat.com>
Thread-Topic: linux-next: manual merge of the akpm tree with Linus' tree
Thread-Index: SfAzCvVy9Yp2FMhZfR9XjEiutokWUQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--__1368422429899TOUCHDOWN_BOUNDARY__
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

=0D=0A-----Original Message-----=0D=0AFrom: Kees Cook [keescook@chromium.org=
]=0D=0AReceived: Monday, 13 May 2013, 12:49am=0D=0ATo: Eric Paris [eparis@re=
dhat.com]=0D=0ACC: Stephen Rothwell [sfr@canb.auug.org.au]; Andrew Morton [a=
kpm@linux-foundation.org]; Linus [torvalds@linux-foundation.org]; Linux-Next=
 [linux-next@vger.kernel.org]; LKML [linux-kernel@vger.kernel.org]; Jeff Lay=
ton [jlayton@redhat.com]; Al Viro [viro@zeniv.linux.org.uk]=0D=0ASubject: Re=
: linux-next: manual merge of the akpm tree with Linus' tree=0D=0A=0D=0AOn S=
un, May 12, 2013 at 7:11 PM, Eric Paris <eparis@redhat.com> wrote:=0D=0A> On=
 Mon, 2013-05-13 at 12:07 +1000, Stephen Rothwell wrote:=0D=0A>> Hi Andrew,=0D=
=0A>>=0D=0A>> Today's linux-next merge of the akpm tree got a conflict in=0D=
=0A>> kernel/auditsc.c between commit b24a30a73054 ("audit: fix event covera=
ge=0D=0A>> of AUDIT_ANOM_LINK") from Linus' tree and commit "audit: fix mq_o=
pen and=0D=0A>> mq_unlink to add the MQ root as a hidden parent audit_names =
record" from=0D=0A>> the akpm tree.=0D=0A>=0D=0A> Actually, I've already pic=
ked the patch up for 3.11.  So Andrew, you can=0D=0A> drop it.=0D=0A>=0D=0A>=
> I fixed it up (see below) and can carry the fix as necessary (no action=0D=
=0A>> is required).=0D=0A>>=0D=0A>> BTW, commit b24a30a73054 from Linus' tre=
e has Eric Paris as Author and=0D=0A>> Committer, but is only Signed-off-by =
Kees Cook.  It is part of a long=0D=0A>> series that did not go anywhere nea=
r linus-next.   I do have an audit=0D=0A>> tree in linux-next=0D=0A>> (git:/=
/git.kernel.org/pub/scm/linux/kernel/git/viro/audit.git#for-next)=0D=0A>> bu=
t that hasn't seen any recent activity.=0D=0A>=0D=0A> I thought I sent you a=
 note asking for audit to get pulled into -next=0D=0A> quite a while back.  =
I'll resend...=0D=0A>=0D=0A=0D=0AHrm, how did the Author get mangled?=0D=0A=0D=
=0A=0D=0AI remember it having a conflict when I tried to merge it (someone e=
lse had changed the same area of the header file). So I used patch -p1 and f=
ixed up the reject by hand. I wonder if I screwed up and used git commit -a =
instead of git am --resolved?   That is 2 things I should have caught on fin=
al review I missed.  :-(=0D=0A=0D=0ANow to wait for everything else I screwe=
d up...

--__1368422429899TOUCHDOWN_BOUNDARY__--
