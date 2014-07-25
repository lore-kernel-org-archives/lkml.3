Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbaGYT3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:29:47 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47193 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaGYT3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:29:46 -0400
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@fusionio.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/14] scsi: add support for a blk-mq based I/O path.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1405678393-11497-1-git-send-email-hch@lst.de>
	<1405678393-11497-14-git-send-email-hch@lst.de>
Date: Fri, 25 Jul 2014 15:29:12 -0400
In-Reply-To: <1405678393-11497-14-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Fri, 18 Jul 2014 12:13:12 +0200")
Message-ID: <yq1bnsdgruf.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> This patch adds support for an alternate I/O path in the scsi
Christoph> midlayer which uses the blk-mq infrastructure instead of the
Christoph> legacy request code.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
