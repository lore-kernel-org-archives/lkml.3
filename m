Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502Ab3LFTxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 14:53:05 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:54058 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab3LFTxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 14:53:03 -0500
Date: Fri, 6 Dec 2013 11:53:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, clm@fb.com,
        viro@zeniv.linux.org.uk, zab@redhat.com, shaggy@kernel.org
Subject: Re: [PATCH 09/11] block: iov_count_pages()
Message-ID: <20131206195302.GB5153@infradead.org>
References: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
 <1386108017-27964-10-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386108017-27964-10-git-send-email-kmo@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needs a better subject, description and probably a comment describing
the function.

I don't think the name choice is a good one either as it checks for
alignment in addition to counting up the vectors.

