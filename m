Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbaLJORJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:17:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:11382 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261AbaLJORH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:17:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,552,1413270000"; 
   d="scan'208";a="651583136"
Date: Wed, 10 Dec 2014 09:12:11 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        willy@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v12 00/20] DAX: Page cache bypass for filesystems on
 memory storage
Message-ID: <20141210141211.GD2220@wil.cx>
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
 <20141210140347.GA23252@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210140347.GA23252@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 06:03:47AM -0800, Christoph Hellwig wrote:
> What is the status of this patch set?

I have no outstanding bug reports against it.  Linus told me that he
wants to see it come through Andrew's tree.  I have an email two weeks
ago from Andrew saying that it's on his list.  I would love to see it
merged since it's almost a year old at this point.
