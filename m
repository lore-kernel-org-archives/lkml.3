Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbaHFWew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 18:34:52 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39511 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754116AbaHFWev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:34:51 -0400
Date: Wed, 6 Aug 2014 23:34:41 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [BUG] nfs3_list_one_acl oops
Message-ID: <20140806223441.GU30282@n2100.arm.linux.org.uk>
References: <20140726162143.GB20396@n2100.arm.linux.org.uk> <20140727131949.GB32153@infradead.org> <CAHQdGtQhEQiuObg48JrNbK5L6=r0mxfSvErVC0JS4TqxxbJy_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQdGtQhEQiuObg48JrNbK5L6=r0mxfSvErVC0JS4TqxxbJy_w@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2014 at 11:15:40AM -0400, Trond Myklebust wrote:
> On Sun, Jul 27, 2014 at 9:19 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > Thanks Russell, the patch looks good.
> 
> No. It needs to use an IS_ERR_OR_NULL() test at least in order to work
> correctly.

What's happening on this?  Did this get fixed for v3.16?

My patch still seems to apply to v3.16 so I guess NFS is broken there...

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
