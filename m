Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab3JJTRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:17:21 -0400
Received: from verein.lst.de ([213.95.11.211]:33939 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545Ab3JJTRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:17:18 -0400
Date: Thu, 10 Oct 2013 21:17:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: scsi-mq updated to latest linux-block/new-queue
Message-ID: <20131010191714.GA3098@lst.de>
References: <1381345971.19256.461.camel@haakon3.risingtidesystems.com> <20131009194658.GA3066@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009194658.GA3066@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What is the criteria for patches to include in your tree? I would suggest
> to consider this one https://lkml.org/lkml/2013/8/9/90 if it fits.

For this one you probably want to send a patch to Jens to move blk-mq-tag.h
to include/linux first instead of doing the relative include hack.

Also the  blk_mq_*tag* routines you use aren't exported, so a modular build of
the driver with that patch applied will fail.

