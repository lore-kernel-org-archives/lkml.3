Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaIVMmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 08:42:37 -0400
Received: from tundra.namei.org ([65.99.196.166]:34475 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbaIVMmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 08:42:36 -0400
Date: Mon, 22 Sep 2014 22:42:30 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] KEYS: Changes for keyrings for security/next
In-Reply-To: <22597.1411342588@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.11.1409222241520.8492@namei.org>
References: <alpine.LRH.2.11.1409201204460.31120@namei.org> <32370.1410886755@warthog.procyon.org.uk> <22597.1411342588@warthog.procyon.org.uk>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014, David Howells wrote:

> James Morris <jmorris@namei.org> wrote:
> 
> > > Can you please pull these changes into security/next.  They include the fixes
> > > tag I previously requested as there's a dependency between these changes and
> > > the fixes.
> > > 
> > 
> > I'm getting this warning after pulling your code:
> > 
> >   CC      crypto/hash_info.o
> > crypto/asymmetric_keys/asymmetric_type.c: In function 
> > asymmetric_key_hex_to_key_id:
> > crypto/asymmetric_keys/asymmetric_type.c:110: warning: ignoring return 
> > value of hex2bin, declared with attribute warn_unused_result
> 
> I've posted an additional patch that moves some of the prevalidation to after
> the memory allocation in asymmetric_key_hex_to_key_id() and added it onto the
> keys-next branch.  Here's a revised pull request.
> ---
> Can you please pull these changes into security/next.  They include the fixes
> tag I previously requested as there's a dependency between these changes and
> the fixes.
> 

Ok, pulled to my next branch.


-- 
James Morris
<jmorris@namei.org>

