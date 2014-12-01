Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635AbaLAWtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:49:14 -0500
Received: from tundra.namei.org ([65.99.196.166]:51362 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbaLAWtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:49:11 -0500
Date: Tue, 2 Dec 2014 09:49:04 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: linux-nfs@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Keyrings (& NFS) fixes
In-Reply-To: <12126.1417429021@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.11.1412020947060.18348@namei.org>
References: <12126.1417429021@warthog.procyon.org.uk>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2014, David Howells wrote:

> Hi James,
> 
> Can you pass these patches on to Linus please?
> 
> The first one fixes the handling of maximum buffer size for key descriptions,
> fixing the size at 4095 + NUL char rather than whatever PAGE_SIZE happens to
> be and permits you to read back the full description without it getting
> clipped because some extra information got prepended.
> 
> The second and third fix a bug in NFS idmapper handling whereby a key
> representing a mapping between an id and a name expires and causing
> EKEYEXPIRED to be seen internally in NFS (which prevents the mapping from
> happening) rather than re-looking up the mapping.
> 
> Thanks,
> David
> ---
> The following changes since commit a6aacbde406eeb6f8fc218b2c6172825f5e73fcf:
> 
>   Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity into next (2014-11-19 21:36:07 +1100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-fixes-20141121
> 

Because these patches are going to current Linus, you need to apply these 
patches to a tree based on his tree, and send a pull req to me for that.


-- 
James Morris
<jmorris@namei.org>

