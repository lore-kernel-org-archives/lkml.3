Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbaIDSJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 14:09:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36849 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbaIDSJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 14:09:19 -0400
Date: Thu, 4 Sep 2014 11:09:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@primarydata.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] locks: flock_make_lock should return a struct file_lock
 (or PTR_ERR)
Message-ID: <20140904180919.GA16897@infradead.org>
References: <1409840855-10557-1-git-send-email-jlayton@primarydata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409840855-10557-1-git-send-email-jlayton@primarydata.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 10:27:35AM -0400, Jeff Layton wrote:
> Eliminate the need for a return pointer.
> 
> Signed-off-by: Jeff Layton <jlayton@primarydata.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
