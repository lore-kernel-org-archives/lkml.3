Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab3KGPQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:16:42 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:53238 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab3KGPQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:16:40 -0500
Date: Thu, 7 Nov 2013 07:16:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [vfs] BUG: spinlock trylock failure on UP on CPU#0, swapper/0
Message-ID: <20131107151634.GA15577@infradead.org>
References: <20131107121042.GB10868@localhost>
 <20131107123031.GA27852@infradead.org>
 <20131107151439.GO13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107151439.GO13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 03:14:39PM +0000, Al Viro wrote:
> It's vfs.git#for-next and it's messed up on cherry-picks; will put the
> saner branch in a few.
> 
> Al, starting to share Linus' distaste for cherry-picks - crap like that
> happens too easily ;-/

I still haven't seen it on any mainlinglist..
