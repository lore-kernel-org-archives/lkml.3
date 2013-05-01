Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab3EAFKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 01:10:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58911 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3EAFKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 01:10:22 -0400
Date: Wed, 1 May 2013 06:10:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next: manual merge of the vfs tree with the powerpc tree
Message-ID: <20130501051014.GA11630@ZenIV.linux.org.uk>
References: <20130501120636.0e54681b2dfb7ebe6aeb27c4@canb.auug.org.au>
 <5180A1AD.4060409@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5180A1AD.4060409@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 10:31:33AM +0530, Vasant Hegde wrote:
> On 05/01/2013 07:36 AM, Stephen Rothwell wrote:
> >Hi Al,
> >
> >Today's linux-next merge of the vfs tree got a conflict in
> >arch/powerpc/kernel/rtas_flash.c between commit fb4696c39573
> >("powerpc/rtas_flash: Fix bad memory access") from the powerpc tree and
> >commits ad18a364f186 ("powerpc/rtas_flash: Free kmem upon module exit")
> >and 2352ad01409d ("ppc: Clean up rtas_flash driver somewhat") from the
> >vfs tree.
> >
> 
> Stephen,
> 
> As Ben mentioned earlier, there are outstanding comments from me which
> needs to be addressed by Dave, before its merged.

What the hell?  Your fixes *are* folded into that commit and according to
Ben it passes testing; is there anything still missing?
