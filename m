Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbaIQXXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 19:23:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35503 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaIQXXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 19:23:14 -0400
Date: Wed, 17 Sep 2014 16:23:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Olaf Hering <ohering@suse.com>
Cc: KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Get rid of warning messages
Message-ID: <20140917232309.GA4554@infradead.org>
References: <1409701396-20226-1-git-send-email-kys@microsoft.com>
 <20140905054014.GA11595@infradead.org>
 <155acb7b8a3d4532aaa280e44f62447f@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20140917073324.GB23716@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917073324.GB23716@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 09:33:24AM +0200, Olaf Hering wrote:
> Christoph,
> 
> what does "review of this" mean?  There are many hv related patches
> floating around.  The removal of the warning in msgid
> <1409701396-20226-1-git-send-email-kys@microsoft.com> looks ok to me.


Thanks, can you give me a Reviewed-by: tag for it?

Also the two patches at
http://thread.gmane.org/gmane.linux.drivers.driver-project.devel/56242/

still need a review, and I'd love to get one to include it for the
3.18 merge window.
