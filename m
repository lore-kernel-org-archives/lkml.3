Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab3LFLJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 06:09:57 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:52255 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab3LFLJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 06:09:56 -0500
Date: Fri, 6 Dec 2013 03:09:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, clm@fb.com,
        viro@zeniv.linux.org.uk, zab@redhat.com, shaggy@kernel.org
Subject: Re: [PATCH 05/11] iov_iter: Move iov_iter to uio.h
Message-ID: <20131206110952.GA1427@infradead.org>
References: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
 <1386108017-27964-6-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386108017-27964-6-git-send-email-kmo@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 02:00:11PM -0800, Kent Overstreet wrote:
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>

Looks like a good enough cleanup on it's own, might be worth to
pick up for .14 independent of the dio changes.

Reviewed-by: Christoph Hellwig <hch@lst.de>
