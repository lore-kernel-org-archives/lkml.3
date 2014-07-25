Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893AbaGYTQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:16:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41386 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbaGYTQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:16:42 -0400
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@fusionio.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/14] scatterlist: allow chaining to preallocated chunks
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1405678393-11497-1-git-send-email-hch@lst.de>
	<1405678393-11497-13-git-send-email-hch@lst.de>
Date: Fri, 25 Jul 2014 15:15:04 -0400
In-Reply-To: <1405678393-11497-13-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Fri, 18 Jul 2014 12:13:11 +0200")
Message-ID: <yq1fvhpgshz.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Blk-mq drivers usually preallocate their S/G list as part of
Christoph> the request, but if we want to support the very large S/G
Christoph> lists currently supported by the SCSI code that would tie up
Christoph> a lot of memory in the preallocated request pool.  Add
Christoph> support to the scatterlist code so that it can initialize a
Christoph> S/G list that uses a preallocated first chunks and
Christoph> dynamically allocated additional chunks.  That way the
Christoph> scsi-mq code can preallocate a first page worth of S/G
Christoph> entries as part of the request, and dynamically extend the
Christoph> S/G list when needed.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
