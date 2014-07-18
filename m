Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422888AbaGRTIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:08:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755377AbaGRTIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:08:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140718092203.3bab9fba@canb.auug.org.au>
References: <20140718092203.3bab9fba@canb.auug.org.au> <23717.1405636445@warthog.procyon.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, mimi.e.zohar@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>, vgoyal@redhat.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Keyrings and asymmetric keys patches for 3.17
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21813.1405710467.1@warthog.procyon.org.uk>
Date: Fri, 18 Jul 2014 20:07:47 +0100
Message-ID: <21814.1405710467@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I hate to be a pest, but this whole branch has only your signed off by
> and no indication that any of it has been reviewed/tested by anyone
> else ...

Okay, I've got at least one review for most of the patches.  I'll try and get
some more, but it probably won't be till next week.

Anyway, I've updated the keys-preparse-1 branch and tagged it anew with
keys-preparse-1-20140718.  There was a spelling fix in the docs and the
patches have been rebased on the updated security/next.

I've also rebuilt the keys-next branch, basing it on the updated
security/next, and tagged it with keys-next-20140718.

	warthog>git diff keys-next-20140717 keys-next-20140718 | diffstat
	 keys.txt |    2 +-
	 1 file changed, 1 insertion(+), 1 deletion(-)

David
