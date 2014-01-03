Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbaACUEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:04:25 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48074 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaACUEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:04:23 -0500
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: status of block-integrity
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20131222192128.GA28532@infradead.org> <52C6D0DB.1050906@suse.de>
Date: Fri, 03 Jan 2014 15:03:42 -0500
In-Reply-To: <52C6D0DB.1050906@suse.de> (Hannes Reinecke's message of "Fri, 03
	Jan 2014 16:01:47 +0100")
Message-ID: <yq1wqigzvc1.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Personally, I doubt it's a good idea to kill it off, but a
Hannes> proper (userland) API for it has been a long time missing.

Before we throw the baby out with the bath water, maybe Darrick can fill
us in on the progress of the aio passthrough interface?

-- 
Martin K. Petersen	Oracle Linux Engineering
