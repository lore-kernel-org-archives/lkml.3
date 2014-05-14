Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaENRmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:42:17 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41227 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaENRmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:42:16 -0400
Date: Wed, 14 May 2014 10:42:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Stephen Rothwell <sfr@au1.ibm.com>
Subject: Re: [PATCH] vfs: call rename2 if exists
Message-ID: <20140514174212.GA28893@infradead.org>
References: <20140514152720.GH17233@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514152720.GH17233@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 05:27:20PM +0200, Miklos Szeredi wrote:
> Al,
> 
> The below patch calls ->rename2() if it exists even for flags == 0.  This will
> allow a gradual elimination of ->rename() implementations and finally merging
> the two ops.
> 
> Please consider pushing this to 3.15, but at least ACK-ing it so I can work on
> followup patches for handing RENAME_NOREPLACE in filesystems.

You'll have my ACK at least:

Acked-by: Christoph Hellwig <hch@lst.de>

