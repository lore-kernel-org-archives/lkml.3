Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaFEKMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 06:12:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36492 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaFEKMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 06:12:24 -0400
Date: Thu, 5 Jun 2014 03:12:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de,
        JBottomley@Parallels.com, venkateshs@google.com
Subject: Re: [PATCH v3 3/6] virtio-scsi: avoid cancelling uninitialized work
 items
Message-ID: <20140605101223.GB8633@infradead.org>
References: <1401881699-1456-1-git-send-email-pbonzini@redhat.com>
 <1401881699-1456-4-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401881699-1456-4-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 01:34:56PM +0200, Paolo Bonzini wrote:
> Calling the workqueue interface on uninitialized work items isn't a
> good idea even if they're zeroed. It's not failing catastrophically only
> through happy accidents.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
