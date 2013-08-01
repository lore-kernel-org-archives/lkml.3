Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab3HAITx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:19:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43389 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3HAITu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:19:50 -0400
Date: Thu, 1 Aug 2013 01:19:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davej@redhat.com, viro@zeniv.linux.org.uk,
        jack@suse.cz, glommer@parallels.com
Subject: Re: [PATCH 08/11] inode: convert per-sb inode list to a list_lru
Message-ID: <20130801081950.GA18828@infradead.org>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
 <1375244150-27296-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375244150-27296-9-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this point the list_lru name really becomes confusing.  Given that
it's not really LRU specific maybe just rename it to pernode_list
or similar?

