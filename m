Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbbAHPhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:37:46 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18416 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797AbbAHPhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:37:43 -0500
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@fb.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/4 v4] brd: Request from fdisk 4k alignment
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <54AD5893.9040701@plexistor.com> <54AD5A42.5040404@plexistor.com>
Date: Thu, 08 Jan 2015 10:37:30 -0500
In-Reply-To: <54AD5A42.5040404@plexistor.com> (Boaz Harrosh's message of "Wed,
	07 Jan 2015 18:09:38 +0200")
Message-ID: <yq1a91t2shx.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Boaz" == Boaz Harrosh <boaz@plexistor.com> writes:

Boaz> Because of the direct_access() API which returns a PFN. partitions
Boaz> better start on 4K boundary, else offset ZERO of a partition will
Boaz> not be aligned and blk_direct_access() will fail the call.

Boaz> By setting blk_queue_physical_block_size(PAGE_SIZE) we can
Boaz> communicate this to fdisk and friends.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
