Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaH2BLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 21:11:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56569 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaH2BLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 21:11:33 -0400
Date: Thu, 28 Aug 2014 18:11:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>, "hare@suse.de" <hare@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] Drivers: scsi: storvsc: Force discovery of LUNs that
 may have been removed.
Message-ID: <20140829011129.GA22458@infradead.org>
References: <1408244954-27417-1-git-send-email-kys@microsoft.com>
 <1408244988-27456-1-git-send-email-kys@microsoft.com>
 <1408244988-27456-2-git-send-email-kys@microsoft.com>
 <20140819175431.GA4617@infradead.org>
 <c5da85b38a2a4b26b9a7a7fadc40bcc2@BY2PR0301MB0711.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5da85b38a2a4b26b9a7a7fadc40bcc2@BY2PR0301MB0711.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 10:54:51PM +0000, KY Srinivasan wrote:
> > This looks pretty reasonable to me, but I wonder if we should move this up
> > to common code so that it happens for any host rescan triggered by sysfs or
> > other drivers as well.
> Ping. Any decision on if/when this patch may be checked in.

I'll need a review or two for it still..
