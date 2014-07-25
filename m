Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761074AbaGYTLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:11:48 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23243 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761049AbaGYTLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:11:46 -0400
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@fusionio.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/14] scsi: only maintain target_blocked if the driver has a target queue limit
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1405678393-11497-1-git-send-email-hch@lst.de>
	<1405678393-11497-11-git-send-email-hch@lst.de>
Date: Fri, 25 Jul 2014 15:10:11 -0400
In-Reply-To: <1405678393-11497-11-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Fri, 18 Jul 2014 12:13:09 +0200")
Message-ID: <yq1oawdgsq4.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> This saves us an atomic operation for each I/O submission and
Christoph> completion for the usual case where the driver doesn't set a
Christoph> per-target can_queue value.  Only a few iscsi hardware
Christoph> offload drivers set the per-target can_queue value at the
Christoph> moment.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
