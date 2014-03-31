Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaCaX1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 19:27:00 -0400
Received: from tundra.namei.org ([65.99.196.166]:41156 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbaCaX06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 19:26:58 -0400
Date: Tue, 1 Apr 2014 10:30:05 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: torvalds@linux-foundation.org, d.kasatkin@samsung.com,
        casey@schaufler-ca.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] KEYS: Make perm request flags available to security
 modules
In-Reply-To: <11268.1396281254@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.02.1404011029370.16115@tundra.namei.org>
References: <alpine.LRH.2.02.1404010231260.16115@tundra.namei.org> <8321.1396272505@warthog.procyon.org.uk> <11268.1396281254@warthog.procyon.org.uk>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014, David Howells wrote:

> James Morris <jmorris@namei.org> wrote:
> 
> > > Can you pull this pair of patches please?  They move the flags that are
> > > used to request specific permissions to a more public header file so that
> > > they can then be used by Smack (and other security modules).
> > 
> > These should be going via my tree.
> 
> Okay, if you could pull them then.  I thought Linus wanted keyrings stuff to
> go separately.

I don't recall that.

I'll pull them after the merge window.


-- 
James Morris
<jmorris@namei.org>
