Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab3KGPOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:14:52 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58032 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3KGPOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:14:50 -0500
Date: Thu, 7 Nov 2013 15:14:39 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [vfs] BUG: spinlock trylock failure on UP on CPU#0, swapper/0
Message-ID: <20131107151439.GO13318@ZenIV.linux.org.uk>
References: <20131107121042.GB10868@localhost>
 <20131107123031.GA27852@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107123031.GA27852@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 04:30:31AM -0800, Christoph Hellwig wrote:
> On Thu, Nov 07, 2013 at 08:10:42PM +0800, Fengguang Wu wrote:
> > Greetings,
> > 
> > I got the below dmesg and the first bad commit seems to be
> > 
> > commit 1247c74b4f3f3725a8bd8dc0bbd22baa2a9049ae
> > Author: David Howells <dhowells@redhat.com>
> > Date:   Thu Sep 12 19:22:53 2013 +0100
> > 
> >     VFS: Put a small type field into struct dentry::d_flags
> 
> Where is that commit coming from?  I can't find any public mentioning of
> it, and big brother from Mountain View can't either.

It's vfs.git#for-next and it's messed up on cherry-picks; will put the
saner branch in a few.

Al, starting to share Linus' distaste for cherry-picks - crap like that
happens too easily ;-/
