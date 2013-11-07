Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab3KGMah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 07:30:37 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:52567 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3KGMae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 07:30:34 -0500
Date: Thu, 7 Nov 2013 04:30:31 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [vfs] BUG: spinlock trylock failure on UP on CPU#0, swapper/0
Message-ID: <20131107123031.GA27852@infradead.org>
References: <20131107121042.GB10868@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107121042.GB10868@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 08:10:42PM +0800, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit seems to be
> 
> commit 1247c74b4f3f3725a8bd8dc0bbd22baa2a9049ae
> Author: David Howells <dhowells@redhat.com>
> Date:   Thu Sep 12 19:22:53 2013 +0100
> 
>     VFS: Put a small type field into struct dentry::d_flags

Where is that commit coming from?  I can't find any public mentioning of
it, and big brother from Mountain View can't either.

