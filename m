Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbaKEOUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:20:30 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49342 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbaKEOU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:20:27 -0500
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@fb.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 4/5] brd: Request from fdisk 4k alignment
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <545A2D69.8090003@plexistor.com> <545A2F52.3040303@plexistor.com>
Date: Wed, 05 Nov 2014 09:20:06 -0500
In-Reply-To: <545A2F52.3040303@plexistor.com> (Boaz Harrosh's message of "Wed,
	05 Nov 2014 16:08:18 +0200")
Message-ID: <yq1k339enl5.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Boaz" == Boaz Harrosh <boaz@plexistor.com> writes:

Hey Boaz,

Boaz> Note that blk_queue_physical_block_size() also trashes io_min, but
Boaz> we can leave this one to be 512. io_min as opposed to
Boaz> physical_block_size will actually change Kernel behavior

Care to elaborate?

Also, fdisk and parted should be aligning on 1MB by default regardless
of block size. So I'm also not sure why you need to trick fdisk to align
by setting the pbs.

-- 
Martin K. Petersen	Oracle Linux Engineering
