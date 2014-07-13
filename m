Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbaGMRRC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 13:17:02 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:17121 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbaGMRQy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 13:16:54 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Benjamin LaHaise <bcrl@kvack.org>
CC: Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@fusionio.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: scsi-mq V2
Thread-Topic: scsi-mq V2
Thread-Index: AQHPnHMrpCazJa2BBk+bOfxdnvD3mpuZzE1ggACP5JCAAAm1gIAAiJyAgAAI4QCAAfDxoIAALgKggAEsdpA=
Date: Sun, 13 Jul 2014 17:15:15 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958BA02EF@G9W0745.americas.hpqcorp.net>
References: <20140710062040.GB20146@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958B96E3B@G9W0745.americas.hpqcorp.net>
 <20140710160422.GA13728@infradead.org>
 <20140710161438.GA30792@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958B971BB@G9W0745.americas.hpqcorp.net>
 <x497g3l10x6.fsf@segfault.boston.devel.redhat.com>
 <94D0CD8314A33A4D9D801C0FE68B402958B9742E@G9W0745.americas.hpqcorp.net>
 <94D0CD8314A33A4D9D801C0FE68B402958B979E6@G9W0745.americas.hpqcorp.net>
 <20140711061441.GA29629@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958B98323@G9W0745.americas.hpqcorp.net>
 <20140711145524.GB12478@kvack.org>
 <94D0CD8314A33A4D9D801C0FE68B402958B9969F@G9W0745.americas.hpqcorp.net>
 <94D0CD8314A33A4D9D801C0FE68B402958B9F2DB@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958B9F2DB@G9W0745.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.27]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Elliott, Robert (Server Storage)
> Sent: Saturday, July 12, 2014 6:20 PM
> To: Benjamin LaHaise
> Cc: Christoph Hellwig; Jeff Moyer; Jens Axboe; dgilbert@interlog.com;
> James Bottomley; Bart Van Assche; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: RE: scsi-mq V2
> 
> > I will see if that solves the problem with the scsi-mq-3 tree, or
> > at least some of the bisect trees leading up to it.
> 
> scsi-mq-3 is still going after 45 minutes.  I'll leave it running
> overnight.
> 

That has been going strong for 18 hours, so I think that's the patch
we need.



