Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaGMOxH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:53:07 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46775 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbaGMOxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:53:04 -0400
To: "Reddy\, Sreekanth" <Sreekanth.Reddy@avagotech.com>
Cc: <jejb@kernel.org>, <JBottomley@Parallels.com>,
        <linux-scsi@vger.kernel.org>, <Sathya.Prakash@avagotech.com>,
        <Nagalakshmi.Nandigama@avagotech.com>, <linux-kernel@vger.kernel.org>,
        <hch@infradead.org>, <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH 01/10][SCSI]mpt2sas: Added driver module parameter max_msix_vectors
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20140625103028.GA12870@avagotech.com>
Date: Sun, 13 Jul 2014 10:52:26 -0400
In-Reply-To: <20140625103028.GA12870@avagotech.com> (Sreekanth Reddy's message
	of "Wed, 25 Jun 2014 16:00:28 +0530")
Message-ID: <yq1ion1z4yd.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Reddy, Sreekanth <Sreekanth.Reddy@avagotech.com> writes:

Sreekanth> Added driver module parameter max_msix_vectors. Using this
Sreekanth> module parameter the maximum number of MSI-X vectors could be
Sreekanth> set.

Sreekanth> The number of MSI-X vectors used would be the minimum of
Sreekanth> MSI-X vectors supported by the HBA, the number of CPU cores
Sreekanth> and the value set to max_msix_vectors module parameters.



-- 
Martin K. Petersen	Oracle Linux Engineering
