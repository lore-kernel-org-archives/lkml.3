Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbaIRQnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:43:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41275 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbaIRQn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:43:28 -0400
Date: Thu, 18 Sep 2014 09:43:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Olaf Hering <ohering@suse.com>
Cc: KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Get rid of warning messages
Message-ID: <20140918164324.GA12287@infradead.org>
References: <1409701396-20226-1-git-send-email-kys@microsoft.com>
 <20140905054014.GA11595@infradead.org>
 <155acb7b8a3d4532aaa280e44f62447f@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20140917073324.GB23716@suse.com>
 <20140917232309.GA4554@infradead.org>
 <20140918115017.GA20884@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140918115017.GA20884@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 01:50:17PM +0200, Olaf Hering wrote:
> On Wed, Sep 17, Christoph Hellwig wrote:
> 
> > Also the two patches at
> > http://thread.gmane.org/gmane.linux.drivers.driver-project.devel/56242/
> 
> Wasnt the outcome that this was a bad idea? Or at least doing it
> globally is bad. In any case, its not something I can help with.

The outcome was that we don't want to do it globally, but it does make
sense for the hyperv case.
