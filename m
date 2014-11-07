Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaKGRmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 12:42:40 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49798 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaKGRmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 12:42:39 -0500
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Chris Friesen <chris.friesen@windriver.com>, Jens Axboe <axboe@kernel.dk>,
        lkml <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: absurdly high "optimal_io_size" on Seagate SAS disk
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <545BA625.40308@windriver.com> <545BAD05.3050800@windriver.com>
	<yq1k338b5d5.fsf@sermon.lab.mkp.net> <545BB3AB.8070409@windriver.com>
	<yq1fvdwb3lq.fsf@sermon.lab.mkp.net> <545BC88A.7060706@windriver.com>
	<yq1zjc3ai4h.fsf@sermon.lab.mkp.net> <545C5A1B.9020206@windriver.com>
	<yq1bnoj9dvu.fsf@sermon.lab.mkp.net>
Date: Fri, 07 Nov 2014 12:42:31 -0500
In-Reply-To: <yq1bnoj9dvu.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Fri, 07 Nov 2014 11:25:25 -0500")
Message-ID: <yq1ioiq9abc.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:

Martin> I know there was a bug open with Seagate. I assume it has been
Martin> fixed in their latest firmware.

Seagate confirms that this issue was fixed about a year ago. Will
provide more data when I have it.

-- 
Martin K. Petersen	Oracle Linux Engineering
