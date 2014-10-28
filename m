Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaJ1AIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:08:18 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21563 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaJ1AIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:08:15 -0400
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] lib/scatterlist: fix memory leak with scsi-mq
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <5449529D.5070804@cybernetics.com>
Date: Mon, 27 Oct 2014 20:07:55 -0400
In-Reply-To: <5449529D.5070804@cybernetics.com> (Tony Battersby's message of
	"Thu, 23 Oct 2014 15:10:21 -0400")
Message-ID: <yq11tptqco4.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Tony" == Tony Battersby <tonyb@cybernetics.com> writes:

Tony> Fix a memory leak with scsi-mq triggered by commands with large
Tony> data transfer length.

Tony> Fixes: c53c6d6a68b1 ("scatterlist: allow chaining to preallocated
Tony> chunks") 

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
