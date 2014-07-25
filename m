Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761123AbaGYTMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:12:41 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39559 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbaGYTMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:12:40 -0400
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@fusionio.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/14] scsi: unwind blk_end_request_all and blk_end_request_err calls
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1405678393-11497-1-git-send-email-hch@lst.de>
	<1405678393-11497-12-git-send-email-hch@lst.de>
Date: Fri, 25 Jul 2014 15:12:05 -0400
In-Reply-To: <1405678393-11497-12-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Fri, 18 Jul 2014 12:13:10 +0200")
Message-ID: <yq1k371gsmy.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Replace the calls to the various blk_end_request variants
Christoph> with opencode equivalents.  Blk-mq is using a model that
Christoph> gives the driver control between the bio updates and the
Christoph> actual completion, and making the old code follow that same
Christoph> model allows us to keep the code more similar for both paths.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
