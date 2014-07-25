Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760989AbaGYTbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:31:49 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32153 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbaGYTbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:31:47 -0400
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@fusionio.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>,
        linux-kernel@vger.kernel.org, Hiral Patel <hiralpat@cisco.com>,
        Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>
Subject: Re: [PATCH 14/14] fnic: reject device resets without assigned tags for the blk-mq case
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1405678393-11497-1-git-send-email-hch@lst.de>
	<1405678393-11497-15-git-send-email-hch@lst.de>
Date: Fri, 25 Jul 2014 15:31:11 -0400
In-Reply-To: <1405678393-11497-15-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Fri, 18 Jul 2014 12:13:13 +0200")
Message-ID: <yq17g31grr4.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Either someone who can actually test the hardware will have
Christoph> to come up with a similar hack for the blk-mq case, or we'll
Christoph> have to bite the bullet and fix the way the EH ioctls work
Christoph> for real, but until that happens we fail these explicit
Christoph> requests here.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
