Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaJSOvj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 10:51:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44454 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaJSOvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 10:51:38 -0400
Date: Sun, 19 Oct 2014 07:51:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH 2/4] fs: add fadvise file_operation
Message-ID: <20141019145138.GB9593@infradead.org>
References: <1413645688-13524-1-git-send-email-dmonakhov@openvz.org>
 <1413645688-13524-3-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413645688-13524-3-git-send-email-dmonakhov@openvz.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2014 at 07:21:26PM +0400, Dmitry Monakhov wrote:
> sys_fadvise result in direct f_mode modification, which  may be not
> suitable for some unusual filesytems where file mode invariant is more
> complex. In order to support such filesystems we have to delegate fadvise
> logic to filesystem layer.

Is there a real use case for it?  So for it seems mostly about ecryptfs,
and even that use is lacking a proper explanation.

Also fadvice and set_flags seem entirely unrelated, I don't understand
why you're throwing fadvice in thise series.

