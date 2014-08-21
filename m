Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbaHUVKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 17:10:48 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40776 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbaHUVKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 17:10:46 -0400
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash <Sathya.Prakash@avagotech.com>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [RESEND][PATCH 8/8][SCSI]mpt3sas: Bump mpt3sas driver version to 04.100.00.00
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20140625104207.GA13042@avagotech.com>
	<yq1a98av9vi.fsf@sermon.lab.mkp.net>
	<CAK=zhgqGVBsgxheZ1ixvGEeOFJ_7fPhO0d4HAh1f4YD1mWG7Sw@mail.gmail.com>
Date: Thu, 21 Aug 2014 17:10:12 -0400
In-Reply-To: <CAK=zhgqGVBsgxheZ1ixvGEeOFJ_7fPhO0d4HAh1f4YD1mWG7Sw@mail.gmail.com>
	(Sreekanth Reddy's message of "Tue, 12 Aug 2014 15:55:43 +0530")
Message-ID: <yq1k361r1l7.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> 1. [RESEND][PATCH 7/8][SCSI]mpt3sas: Added Reply Descriptor
Sreekanth>    Post Queue (RDPQ) Array support

Please make the change suggested by Joe Perches and then repost both
mpt2sas and mpt3sas with the appropriate SoB and RB tags so they are
easy for Christoph to pick up.

The only patch I'd like to dig deeper into before accepting it is the
unblock one.

-- 
Martin K. Petersen	Oracle Linux Engineering
