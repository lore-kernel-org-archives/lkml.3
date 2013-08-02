Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab3HBKth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:49:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48764 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab3HBKte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:49:34 -0400
Date: Fri, 2 Aug 2013 03:49:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Xiong Zhou <jencce.kernel@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, Paul Bolle <pebolle@tiscali.nl>,
        Jiri Kosina <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH v2] staging/lustre: lloop depends on BLOCK
Message-ID: <20130802104930.GB1718@infradead.org>
References: <20130801084539.GA13306@infradead.org>
 <CE20190F.5958F%andreas.dilger@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CE20190F.5958F%andreas.dilger@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 07:57:22PM +0000, Dilger, Andreas wrote:
> It provides significant performance improvement for network IO on Lustre.
> It bypasses DLM locking in Lustre and the VFS layer on the client, copying
> in the loop driver, and page-by-page IO submission in the normal IO path.

Part of being upstream is improving existing drivers instead of copy and
pasting them.  Please take a Look at Shaggys in-kernel direct I/O and
loop improvements and submit any incremental improvements ontop of that
one.

