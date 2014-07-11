Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaGKGDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 02:03:19 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:50805 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaGKGDR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 02:03:17 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Jeff Moyer <jmoyer@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@fusionio.com>,
        Benjamin LaHaise <bcrl@kvack.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: scsi-mq V2
Thread-Topic: scsi-mq V2
Thread-Index: AQHPnHMrpCazJa2BBk+bOfxdnvD3mpuZzE1ggACP5JA=
Date: Fri, 11 Jul 2014 06:02:03 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B979E6@G9W0745.americas.hpqcorp.net>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
	<20140708144829.GA5539@infradead.org> <53BD7041.5010300@interlog.com>
	<53BD9A24.7010203@kernel.dk>
	<94D0CD8314A33A4D9D801C0FE68B402958B9628B@G9W0745.americas.hpqcorp.net>
	<20140710062040.GB20146@infradead.org>
	<94D0CD8314A33A4D9D801C0FE68B402958B96E3B@G9W0745.americas.hpqcorp.net>
	<20140710160422.GA13728@infradead.org>
	<20140710161438.GA30792@infradead.org>
	<94D0CD8314A33A4D9D801C0FE68B402958B971BB@G9W0745.americas.hpqcorp.net>
 <x497g3l10x6.fsf@segfault.boston.devel.redhat.com>
 <94D0CD8314A33A4D9D801C0FE68B402958B9742E@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958B9742E@G9W0745.americas.hpqcorp.net>
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
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Elliott, Robert (Server Storage)
> 
> I added some prints in aio_setup_ring and  ioctx_alloc and
> rebooted.  This time it took much longer to hit the problem.  It
> survived dozens of ^Cs.  Running a few minutes, though, IOPS
> eventually dropped.  So, sometimes it happens immediately,
> sometimes it takes time to develop.
> 
> I will rerun bisect-1 -2 and -3 for longer times to increase
> confidence that they didn't just appear good.

Allowing longer run times before declaring success, the problem 
does appear in all of the bisect trees.  I just let fio
continue to run for many minutes - no ^Cs necessary.

no-rebase: good for > 45 minutes (I will leave that running for
  8 more hours)
bisect-1: bad
bisect-2: bad
bisect-3: bad
bisect-4: bad


