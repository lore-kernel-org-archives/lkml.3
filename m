Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaKGWFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 17:05:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbaKGWFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 17:05:49 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4109261.WfcAOoSvNG@sifl>
References: <4109261.WfcAOoSvNG@sifl> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154238.2555.85960.stgit@warthog.procyon.org.uk>
To: Paul Moore <paul@paul-moore.com>
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] Overlayfs: Use copy-up security hooks
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3147.1415397940.1@warthog.procyon.org.uk>
Date: Fri, 07 Nov 2014 22:05:40 +0000
Message-ID: <3148.1415397940@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Moore <paul@paul-moore.com> wrote:

> So the LSM must modify the xattr in place?  I suppose that since the @value
> is allocated to the max size it shouldn't be a problem.  Just checking ...

... And the caller must provide a maximally sized buffer (which it likely has
to allocate anyway).

I'm not sure I really need to provide the modification thing.  I suspect a
binary keep or discard decision is sufficient.

David
