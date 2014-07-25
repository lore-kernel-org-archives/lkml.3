Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207AbaGYLis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:38:48 -0400
Received: from verein.lst.de ([213.95.11.211]:36934 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbaGYLir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:38:47 -0400
Date: Fri, 25 Jul 2014 13:38:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@fusionio.com>,
        Mike Christie <michaelc@cs.wisc.edu>, Robert Elliott <Elliott@hp.com>,
        Webb Scales <webbnh@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/14] scsi: convert host_busy to atomic_t
Message-ID: <20140725113841.GA3043@lst.de>
References: <1405678393-11497-1-git-send-email-hch@lst.de> <1405678393-11497-8-git-send-email-hch@lst.de> <yq1lhrmkovo.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1lhrmkovo.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 12:18:19AM -0400, Martin K. Petersen wrote:
> More nitpicking. In the two previous atomic conversion patches you kept
> %hu for the atomic_t. Here it's %d.

I'll fix it to use %d everywhere, given that's it's not an unsigned short
anymore.

