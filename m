Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaBXTwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:52:11 -0500
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:35228 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753099AbaBXTwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:52:09 -0500
Date: Mon, 24 Feb 2014 13:52:07 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: David Howells <dhowells@redhat.com>
cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        akpm <akpm@linux-foundation.org>
Subject: Re: Has slab ctor operation changed? -- was [PATCH 1/1] afs:
 afs_alloc_inode: use kmem_cache_zalloc
In-Reply-To: <32740.1392934995@warthog.procyon.org.uk>
Message-ID: <alpine.DEB.2.10.1402241347050.20839@nuc>
References: <20140220211612.506074a7fd876e47130a8c5c@skynet.be> <32740.1392934995@warthog.procyon.org.uk>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014, David Howells wrote:

> Of course, it's possible that the slab allocator no longer works like this...

They still work like that (aside from SLOB that calls the ctor on each
alloc but that also has never changed).

