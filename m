Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaHLKZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 06:25:58 -0400
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:51642 "EHLO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaHLKZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 06:25:56 -0400
MIME-Version: 1.0
In-Reply-To: <yq14myiwop0.fsf@sermon.lab.mkp.net>
References: <20140625103640.GA12969@avagotech.com>
	<yq14myiwop0.fsf@sermon.lab.mkp.net>
Date: Tue, 12 Aug 2014 15:55:55 +0530
Message-ID: <CAK=zhgq6p_egcV2HPqDCD2DJGw0-aSO4dg=5YPhKh+3GmOqbxA@mail.gmail.com>
Subject: Re: [RESEND][PATCH 10/10][SCSI]mpt2sas: Bump mpt2sas driver version
 to 18.100.00.00
From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash <Sathya.Prakash@avagotech.com>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

Among the mpt2sas phase17 and phase18 patch set, following are the
patches which you have completed the review

1. [RESEND][PATCH 01/10][SCSI]mpt2sas: Added driver module parameter
max_msix_vectors
2. [RESEND][PATCH 02/10][SCSI]mpt2sas: MPI2 Rev Y (2.00.17) and Rev Z
(2.00.18) specifications
3. [RESEND][PATCH 03/10][SCSI]mpt2sas: Copyright in driver sources is
updated for year the 2014
4. [RESEND][PATCH 04/10][SCSI]mpt2sas: Clear PFA Status on SGPIO when
PFA Drive is Removed or Replaced
5. [RESEND][PATCH 05/10][SCSI]mpt2sas: Bump mpt2sas driver version to
17.100.00.00
6. [PATCH] [SCSI] mpt2sas: Avoid type casting for direct I/O commands
7. [RESEND][PATCH 10/10][SCSI]mpt2sas: Bump mpt2sas driver version to
18.100.00.00

Following are the patches which are remain for review completion

1. [RESEND][PATCH 07/10][SCSI]mpt2sas: Added Reply Descriptor Post
Queue (RDPQ) Array support
2. [RESEND][PATCH 08/10] [scsi] mpt2sas: Get IOC_FACTS information
using handshake protocol only after HBA card gets into READY or
Operational state.
3. [RESEND][PATCH 09/10][SCSI]mpt2sas: Added module parameter
'unblock_io' to unblock IO's during disk

So, Can you please review these three patches, so that I can repost
this patch set once again by appending your Signed-off-by signature.

Regards,
Sreekanth


On Tue, Jul 15, 2014 at 10:21 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Sreekanth" == Reddy, Sreekanth <Sreekanth.Reddy@avagotech.com> writes:
>
> Sreekanth> Bump mpt2sas driver version to 18.100.00.00.
>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
>
> --
> Martin K. Petersen      Oracle Linux Engineering
