Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbaDBLKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 07:10:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58682 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057AbaDBLKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:10:39 -0400
Date: Wed, 2 Apr 2014 04:10:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Richard Hansen <rhansen@bbn.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, Greg Troxel <gdt@ir.bbn.com>
Subject: Re: [PATCH] mm: msync: require either MS_ASYNC or MS_SYNC
Message-ID: <20140402111032.GA27551@infradead.org>
References: <533B04A9.6090405@bbn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533B04A9.6090405@bbn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 02:25:45PM -0400, Richard Hansen wrote:
> For the flags parameter, POSIX says "Either MS_ASYNC or MS_SYNC shall
> be specified, but not both." [1]  There was already a test for the
> "both" condition.  Add a test to ensure that the caller specified one
> of the flags; fail with EINVAL if neither are specified.

This breaks various (sloppy) existing userspace for no gain.

NAK.

