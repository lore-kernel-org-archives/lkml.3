Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaKGSD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:03:59 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25016 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbaKGSD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:03:57 -0500
To: Chris Friesen <chris.friesen@windriver.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>
Subject: Re: absurdly high "optimal_io_size" on Seagate SAS disk
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <545BA625.40308@windriver.com> <545BAD05.3050800@windriver.com>
	<yq1k338b5d5.fsf@sermon.lab.mkp.net> <545BB3AB.8070409@windriver.com>
	<yq1fvdwb3lq.fsf@sermon.lab.mkp.net> <545BC88A.7060706@windriver.com>
	<yq1zjc3ai4h.fsf@sermon.lab.mkp.net> <545C5A1B.9020206@windriver.com>
	<yq1bnoj9dvu.fsf@sermon.lab.mkp.net>
	<yq1ioiq9abc.fsf@sermon.lab.mkp.net> <545D06AC.7000606@windriver.com>
Date: Fri, 07 Nov 2014 13:03:47 -0500
In-Reply-To: <545D06AC.7000606@windriver.com> (Chris Friesen's message of
	"Fri, 7 Nov 2014 11:51:40 -0600")
Message-ID: <yq1egte99bw.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Chris" == Chris Friesen <chris.friesen@windriver.com> writes:

Chris> Apparently there's a new firmware available, dated Oct 13 but
Chris> with no release notes.  We just tried updating the firmware on
Chris> one of the drives in question and it failed from two different
Chris> versions of linux,

Did you use sg_write_buffer or some special firmware update tool?

-- 
Martin K. Petersen	Oracle Linux Engineering
