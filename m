Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaJ1AY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:24:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26744 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaJ1AY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:24:56 -0400
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Meelis Roos <mroos@linux.ee>,
        David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: set REQ_QUEUE for the blk-mq case
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1413731638-28305-1-git-send-email-hch@lst.de>
	<1413731638-28305-3-git-send-email-hch@lst.de>
Date: Mon, 27 Oct 2014 20:24:45 -0400
In-Reply-To: <1413731638-28305-3-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Sun, 19 Oct 2014 17:13:58 +0200")
Message-ID: <yq1sii9oxbm.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> To generate the right SPI tag messages we need to properly
Christoph> set QUEUE_FLAG_QUEUED in the request_queue and mirror it to
Christoph> the request.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
