Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaHFO2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:28:51 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33364 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaHFO2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:28:50 -0400
Date: Wed, 6 Aug 2014 07:28:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] xfs: Remove typedef xfs_uu_t
Message-ID: <20140806142847.GA9757@infradead.org>
References: <20140806141343.GA15659@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806141343.GA15659@himangi-Dell>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 07:43:43PM +0530, Himangi Saraogi wrote:
> The Linux kernel coding style guidelines suggest not using typedefs
> for structure types. This patch gets rid of the typedef for xfs_uu_t.
> Also the names of the struct is changed to drop the _t, to make the
> name look less typedef-like.

The right fix is to just kill the type, and read the values directly
from the uuid_t type using get_unaligned_be16.

