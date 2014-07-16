Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965668AbaGPRWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:22:51 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:36864 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438AbaGPRWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:22:48 -0400
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash <Sathya.Prakash@avagotech.com>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH 08/10][SCSI]mpt2sas: Get IOC_FACTS information using handshake protocol only after HBA card gets into READY or Operational state
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20140625103532.GA12953@avagotech.com>
	<yq1wqbetsf2.fsf@sermon.lab.mkp.net>
	<CAK=zhgoWvnXFdGqVevWJmLpDebb0fq9euYjxJE+EEGYqLoPrhw@mail.gmail.com>
	<20140716070651.GA17886@infradead.org>
Date: Wed, 16 Jul 2014 13:22:11 -0400
In-Reply-To: <20140716070651.GA17886@infradead.org> (Christoph Hellwig's
	message of "Wed, 16 Jul 2014 00:06:51 -0700")
Message-ID: <yq1sim1rzgc.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Sreekanth,

I just sent out a patch for the direct I/O type cast issue. Please add
your SoB to that and use it to replace patch 6 when you send out the
final series.

Christoph> Btw, it would be good to resend the series with the various
Christoph> updates from Martin once he's done with the review.  That
Christoph> makes it a lot easier for me to pick it up.

I'm at T10 this week so I don't have a ton of time. But I'll try to get
the remaining couple of patches reviewed today or tomorrow. And then you
should send out the entire series again with my Reviewed-by: added to
the remaining patches to make life easier for Christoph.

-- 
Martin K. Petersen	Oracle Linux Engineering
