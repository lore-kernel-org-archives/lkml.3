Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaJ1AX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:23:28 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32014 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbaJ1AX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:23:26 -0400
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Meelis Roos <mroos@linux.ee>,
        David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert "block: all blk-mq requests are tagged"
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1413731638-28305-1-git-send-email-hch@lst.de>
	<1413731638-28305-2-git-send-email-hch@lst.de>
Date: Mon, 27 Oct 2014 20:23:13 -0400
In-Reply-To: <1413731638-28305-2-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Sun, 19 Oct 2014 17:13:57 +0200")
Message-ID: <yq1wq7loxe6.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> This reverts commit fb3ccb5da71273e7f0d50b50bc879e50cedd60e7.
Christoph> SCSI-2/SPI actually needs the tagged/untagged flag in the
Christoph> request to work properly.  Revert this patch and add a follow
Christoph> on to set it in the right place.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
