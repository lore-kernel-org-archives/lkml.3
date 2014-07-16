Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030496AbaGPHHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:07:01 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58325 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030460AbaGPHG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:06:56 -0400
Date: Wed, 16 Jul 2014 00:06:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash <Sathya.Prakash@avagotech.com>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [RESEND][PATCH 08/10][SCSI]mpt2sas: Get IOC_FACTS information
 using handshake protocol only after HBA card gets into READY or Operational
 state
Message-ID: <20140716070651.GA17886@infradead.org>
References: <20140625103532.GA12953@avagotech.com>
 <yq1wqbetsf2.fsf@sermon.lab.mkp.net>
 <CAK=zhgoWvnXFdGqVevWJmLpDebb0fq9euYjxJE+EEGYqLoPrhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=zhgoWvnXFdGqVevWJmLpDebb0fq9euYjxJE+EEGYqLoPrhw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 12:00:22PM +0530, Sreekanth Reddy wrote:
> Next time onwards I will follow as per your suggestions while posting the
> patches to upstream.

Btw, it would be good to resend the series with the various updates from
Martin once he's done with the review.  That makes it a lot easier for
me to pick it up.

If you want to make my life even easier send the series using
git-send-patch so that it's properly threaded.

