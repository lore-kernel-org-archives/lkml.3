Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaGJPwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 11:52:37 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:52640 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbaGJPwf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 11:52:35 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Jens Axboe <axboe@kernel.dk>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@fusionio.com>,
        Benjamin LaHaise <bcrl@kvack.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: scsi-mq V2
Thread-Topic: scsi-mq V2
Thread-Index: AQHPkJV9pCazJa2BBk+bOfxdnvD3mpuWVjGAgAGxWICAADHvAIAAUqSAgABg3QCAAJeNgA==
Date: Thu, 10 Jul 2014 15:51:44 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B96E3B@G9W0745.americas.hpqcorp.net>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
 <20140708144829.GA5539@infradead.org> <53BD7041.5010300@interlog.com>
 <53BD9A24.7010203@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B402958B9628B@G9W0745.americas.hpqcorp.net>
 <20140710062040.GB20146@infradead.org>
In-Reply-To: <20140710062040.GB20146@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, 10 July, 2014 1:21 AM
> To: Elliott, Robert (Server Storage)
> Cc: Jens Axboe; dgilbert@interlog.com; Christoph Hellwig; James Bottomley;
> Bart Van Assche; Benjamin LaHaise; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: scsi-mq V2
> 
> On Thu, Jul 10, 2014 at 12:53:36AM +0000, Elliott, Robert (Server Storage)
> wrote:
> > the problem still occurs - fio results in low or 0 IOPS, with perf top
> > reporting unusual amounts of time spent in do_io_submit and io_submit.
> 
> The diff between the two version doesn't show too much other possible
> interesting commits, the most interesting being some minor block
> updates.
> 
> I guess we'll have to a manual bisect, I've pushed out a

> scsi-mq.3-bisect-1 branch that is rebased to just before the merge of
> the block tree

good.

> and a scsi-mq.3-bisect-2 branch that is just after the merge of the 
> block tree to get started.

good.


