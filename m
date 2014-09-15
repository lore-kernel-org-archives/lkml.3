Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaIOVRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:17:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34458 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbaIOVPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:15:41 -0400
Date: Mon, 15 Sep 2014 14:15:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 6/7] move flags enforcement to vfs_preadv/vfs_pwritev
Message-ID: <20140915211541.GB5481@infradead.org>
References: <cover.1410810247.git.milosz@adfin.com>
 <b7faca081076f52327690ebb7fecd1f1bf05a07c.1410810247.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7faca081076f52327690ebb7fecd1f1bf05a07c.1410810247.git.milosz@adfin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should simply be folded into patch 2.
