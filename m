Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaIORF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 13:05:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52873 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaIORF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 13:05:26 -0400
Date: Mon, 15 Sep 2014 10:05:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tomas Henzl <thenzl@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Ching Huang <ching2048@areca.com.tw>, jbottomley@parallels.com,
        dan.carpenter@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 16/17] arcmsr: support new adapter ARC12x4 series
Message-ID: <20140915170519.GB31009@infradead.org>
References: <1408433122.4748.73.camel@Centos6.3-64>
 <53FDE490.1070201@redhat.com>
 <1409240809.4762.259.camel@Centos6.3-64>
 <53FF2544.8020601@redhat.com>
 <20140909163057.GA25745@infradead.org>
 <541020CB.8010302@redhat.com>
 <5416E858.7010709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5416E858.7010709@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 03:23:36PM +0200, Tomas Henzl wrote:
> Christoph,
> 
> you may add my 'reviewed-by' to the arcmsr series
> http://git.infradead.org/users/hch/scsi-queue.git/tree/arcmsr-for-3.18:/drivers/scsi/arcmsr
> with the '[PATCH v5 2/2] arcmsr: simplify of updating doneq_index and postq_index'
> ( https://lkml.org/lkml/2014/9/15/177 ) on top of the series
> that last patch fixes the 16/17 from your git.
> I hope the series is an iteration in the right direction.
> Skip the the '[PATCH v4 1/2] arcmsr: simplify ioctl data read/write', Ching will repost it later.

Thanks a lot Tomas for all the review, and thanks Ching for the patches
and updates.  I'll merge the branch and the additional patch today.
