Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab3HLLwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 07:52:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35261 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab3HLLwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 07:52:40 -0400
Date: Mon, 12 Aug 2013 04:52:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Philippe De Muyter <phdm@macqel.be>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Karel Zak <kzak@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/5] Add aix lvm partitions support files
Message-ID: <20130812115234.GA7709@infradead.org>
References: <1367270313-18871-1-git-send-email-phdm@macqel.be>
 <1367270313-18871-3-git-send-email-phdm@macqel.be>
 <20130520163927.8e4c2fe753b60a02c368ceb5@linux-foundation.org>
 <20130521072754.GB19266@frolo.macqel>
 <20130524100452.GA15570@infradead.org>
 <20130524105852.GA26617@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130524105852.GA26617@frolo.macqel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 12:58:52PM +0200, Philippe De Muyter wrote:
> > This very much screams like it should be implemented in the lvm2
> > userspace package using the dm kernel driver.
> 
> Is lvm2 a generic tool for discovering foreign partition layouts, or it is
> about one linux-specific lvm implementation ?

lvm is mostly about the Linux specific formats.  If you want to create
a separate userspace consumer for device mapper that's probably also
fine, but if you need support for complex layours device mapper is the
way to go, and the partitioning layer isn't getting you anywhere.

