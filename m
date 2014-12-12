Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965672AbaLLKdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:33:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758149AbaLLKdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:33:01 -0500
Date: Fri, 12 Dec 2014 11:32:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Christoph Hellwig <hch@infradead.org>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 6/7] btrfs: add EXTENT_FLAG_SWAPFILE
Message-ID: <20141212103259.GM27601@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>, Chris Mason <clm@fb.com>,
	Josef Bacik <jbacik@fb.com>,
	Trond Myklebust <trond.myklebust@primarydata.com>,
	Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1418173063.git.osandov@osandov.com>
 <f489d4ad85df4039f3a84f1a2f89735c9a1cf88d.1418173063.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f489d4ad85df4039f3a84f1a2f89735c9a1cf88d.1418173063.git.osandov@osandov.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 05:45:47PM -0800, Omar Sandoval wrote:
> Extents mapping a swap file should remain pinned in memory in order to
> avoid doing allocations to look up an extent when we're already low on
> memory. Rather than overloading EXTENT_FLAG_PINNED, add a new flag
> specifically for this purpose.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
