Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3EMCLW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 22:11:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab3EMCLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 22:11:19 -0400
Message-ID: <1368411070.929.19.camel@localhost>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
From: Eric Paris <eparis@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>,
        Kees Cook <keescook@chromium.org>, Al Viro <viro@ZenIV.linux.org.uk>
Date: Sun, 12 May 2013 22:11:10 -0400
In-Reply-To: <20130513120728.f3f469e5d71b39ec78800175@canb.auug.org.au>
References: <20130513120728.f3f469e5d71b39ec78800175@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 12:07 +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got a conflict in
> kernel/auditsc.c between commit b24a30a73054 ("audit: fix event coverage
> of AUDIT_ANOM_LINK") from Linus' tree and commit "audit: fix mq_open and
> mq_unlink to add the MQ root as a hidden parent audit_names record" from
> the akpm tree.

Actually, I've already picked the patch up for 3.11.  So Andrew, you can
drop it.

> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> BTW, commit b24a30a73054 from Linus' tree has Eric Paris as Author and
> Committer, but is only Signed-off-by Kees Cook.  It is part of a long
> series that did not go anywhere near linus-next.   I do have an audit
> tree in linux-next
> (git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit.git#for-next)
> but that hasn't seen any recent activity.

I thought I sent you a note asking for audit to get pulled into -next
quite a while back.  I'll resend...

