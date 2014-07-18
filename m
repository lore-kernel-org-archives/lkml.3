Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761798AbaGRPLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:11:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33429 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033AbaGRPLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:11:40 -0400
Date: Fri, 18 Jul 2014 08:11:31 -0700
From: "Christoph Hellwig (hch@infradead.org)" <hch@infradead.org>
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: KY Srinivasan <kys@microsoft.com>, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <jbottomley@parallels.com>,
        "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>,
        "Christoph Hellwig (hch@infradead.org)" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Message-ID: <20140718151131.GB7425@infradead.org>
References: <1401901323.17510.23.camel@dabdike>
 <d61f4b87a72544e4b0c1e1872a76f97b@BY2PR03MB299.namprd03.prod.outlook.com>
 <53911A35.7010805@cs.wisc.edu>
 <d9854e6ff97f4b0087dbe835a2a57c8f@BY2PR03MB299.namprd03.prod.outlook.com>
 <5391F801.4010107@cs.wisc.edu>
 <1402077167.2207.89.camel@dabdike.int.hansenpartnership.com>
 <539206FA.1020001@kernel.dk>
 <5b926a0a9f264edda91c7c2ab0acb7d1@BY2PR03MB299.namprd03.prod.outlook.com>
 <13807d2cc8744ae1bc374f20d8f9caec@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <94D0CD8314A33A4D9D801C0FE68B402958BAC6DC@G9W0745.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958BAC6DC@G9W0745.americas.hpqcorp.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 12:51:06AM +0000, Elliott, Robert (Server Storage) wrote:
> SYNCHRONIZE CACHE (16) should be favored over SYNCHRONIZE 
> CACHE (10) unless SYNCHRONIZE CACHE (10) is not supported.

I gues you mean (16) for the last occurance?  What's the benefit of
using SYNCHRONIZE CACHE (16) if we don't pass a LBA range?

