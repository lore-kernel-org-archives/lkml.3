Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab3IRLxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 07:53:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab3IRLxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 07:53:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130918115000.b78a5e79d65aa23ced0ac8e4@canb.auug.org.au>
References: <20130918115000.b78a5e79d65aa23ced0ac8e4@canb.auug.org.au> <alpine.LRH.2.02.1309120141280.4317@tundra.namei.org> <alpine.LRH.2.02.1309071426400.29124@tundra.namei.org> <alpine.LRH.2.02.1309070309360.24160@tundra.namei.org> <12075.1378340063@warthog.procyon.org.uk> <17000.1378488989@warthog.procyon.org.uk> <10114.1378806359@warthog.procyon.org.uk> <19686.1379426149@warthog.procyon.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>, simo@redhat.com,
        zohar@linux.vnet.ibm.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Keyrings patches
Date: Wed, 18 Sep 2013 12:53:06 +0100
Message-ID: <1320.1379505186@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Is there some reason that those fixups cannot be done in a merge commit?
> i.e. are they more than simple text updates?

That's somewhat up to James.  *He* would be the person doing the merge, not
me.  I'm changing the lines in my patches also.

> /me thinks that most rebases people do can be better done (and
> documented) as merges.

That depends on how you define "better".  Better for what?  I think it's
better to absorb the changes into my patch series.  StGIT is very good for
handling this, since my patches are currently maintained as an StGIT set.
That way, there ends up one fewer commit in the history, assuming no other
collisions with what James merges.

David
