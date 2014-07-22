Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbaGVDsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 23:48:03 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51406 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaGVDsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 23:48:00 -0400
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@fusionio.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/14] scsi: centralize command re-queueing in scsi_dispatch_fn
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1405678393-11497-1-git-send-email-hch@lst.de>
	<1405678393-11497-4-git-send-email-hch@lst.de>
Date: Mon, 21 Jul 2014 23:46:22 -0400
In-Reply-To: <1405678393-11497-4-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Fri, 18 Jul 2014 12:13:02 +0200")
Message-ID: <yq17g36m4xd.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Make sure we only have the logic for requeing commands in one
Christoph> place.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
