Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab3HWMeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:34:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40427 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab3HWMeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:34:09 -0400
To: dgilbert@interlog.com
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Martin Petersen <martin.petersen@oracle.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Roland Dreier <roland@purestorage.com>, Zach Brown <zab@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Theodore Tso <tytso@mit.edu>,
        James Bottomley <JBottomley@Parallels.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/9] target: Add support for EXTENDED_COPY (VAAI) offload emulation
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1377224821-23422-1-git-send-email-nab@daterainc.com>
	<521741B7.9020904@interlog.com>
Date: Fri, 23 Aug 2013 08:33:46 -0400
In-Reply-To: <521741B7.9020904@interlog.com> (Douglas Gilbert's message of
	"Fri, 23 Aug 2013 13:04:23 +0200")
Message-ID: <yq17gfc60yd.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> The SCSI opcodes associated with it (0x83 and 0x84) have been
Doug> renamed THIRD PARTY COPY OUT and IN, and

Where did you see that? My SPC still has EXTENDED COPY.


Doug> Confused? I certainly was.

Yeah, this is UNMAP all over again, just 100 times worse :(

Anyway. Excited to see nab posting the patches! My copy offload code
from the spring has been getting stale both in the T10 and the kernel
sense. But at least we know what I'll be working on next week :)

-- 
Martin K. Petersen	Oracle Linux Engineering
