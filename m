Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaIYNr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:47:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60459 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaIYNr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:47:28 -0400
Date: Thu, 25 Sep 2014 06:47:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: hare@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] Drivers: scsi: storvsc: Fix issues with
 hot-add/remove of LUNs
Message-ID: <20140925134726.GA26946@infradead.org>
References: <1408244954-27417-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408244954-27417-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So can anywayone give me a review for those two patches?  

On Sat, Aug 16, 2014 at 08:09:14PM -0700, K. Y. Srinivasan wrote:
> This patch-set addresses issues with LUN hot-add and remove. When the host
> notifies the guest that a scan is needed, scan the host. Also, prior to
> discovering new devices that may have been added, ensure we handle the
> LUN remove case first.
> 
> K. Y. Srinivasan (2):
>   Drivers: scsi: storvsc: In responce to a scan event, scan the host
>   Drivers: scsi: storvsc: Force discovery of LUNs that may have been
>     removed.
> 
>  drivers/scsi/storvsc_drv.c |   43 ++++++++++++++++++++++++++++++++-----------
>  1 files changed, 32 insertions(+), 11 deletions(-)
> 
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
