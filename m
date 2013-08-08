Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965808Ab3HHPKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 11:10:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48680 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965740Ab3HHPKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 11:10:02 -0400
Date: Thu, 8 Aug 2013 08:09:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: axboe@kernel.dk, neilb@suse.de, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH 0/22] Immutable biovecs, block layer changes
Message-ID: <20130808150954.GA30092@infradead.org>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 02:54:09PM -0700, Kent Overstreet wrote:
> _However_, I have more patches (that depend on this patch series) to get
> that back - segment merging improvements that get rid of
> bi_seg_front_size, bi_seg_back_size, and bi_phys_segments. Once all that
> is in it should be a net reduction to the size of struct bio.

What is preventing you from sending those out as well?  While it's not
absolutely nessecary it would certainly be good if we'd avoid a struct
bio size regression.

