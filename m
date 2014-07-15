Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaGOQwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 12:52:54 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35543 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbaGOQwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 12:52:51 -0400
To: "Reddy\, Sreekanth" <Sreekanth.Reddy@avagotech.com>
Cc: <jejb@kernel.org>, <JBottomley@Parallels.com>,
        <linux-scsi@vger.kernel.org>, <Sathya.Prakash@avagotech.com>,
        <Nagalakshmi.Nandigama@avagotech.com>, <linux-kernel@vger.kernel.org>,
        <hch@infradead.org>, <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH 1/8][SCSI]mpt3sas: MPI2.5 Rev G (2.5.2) specifications
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20140625103835.GA12993@avagotech.com>
Date: Tue, 15 Jul 2014 12:52:19 -0400
In-Reply-To: <20140625103835.GA12993@avagotech.com> (Sreekanth Reddy's message
	of "Wed, 25 Jun 2014 16:08:35 +0530")
Message-ID: <yq1zjgava2k.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Reddy, Sreekanth <Sreekanth.Reddy@avagotech.com> writes:

Sreekanth> Below is the change set in MPI2.5 Rev G specification and
Sreekanth> 2.00.31 header files
Sreekanth> 1) Added SCSIStatusQualifier to SCSI IO Error Reply message.
Sreekanth> 2) Added ATA Security Freeze Lock to IO Unit Page 1 Flags
Sreekanth>    field.
Sreekanth> 3) Added Allow Protection Information bit for IR Volume
Sreekanth>    Create.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
