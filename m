Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbaCNUlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 16:41:25 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36804 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbaCNUlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 16:41:24 -0400
To: "Reddy\, Sreekanth" <Sreekanth.Reddy@lsi.com>
Cc: <jejb@kernel.org>, <JBottomley@Parallels.com>,
        <linux-scsi@vger.kernel.org>, <Sathya.Prakash@lsi.com>,
        <Nagalakshmi.Nandigama@lsi.com>, <linux-kernel@vger.kernel.org>,
        <sreekanthreddy0547@gmail.com>
Subject: Re: [PATCH 08/11][SCSI]mpt2sas: Added Reply Descriptor Post Queue (RDPQ) Array support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20140314154256.GA8041@lsi.com>
Date: Fri, 14 Mar 2014 16:41:00 -0400
In-Reply-To: <20140314154256.GA8041@lsi.com> (Sreekanth Reddy's message of
	"Fri, 14 Mar 2014 21:12:56 +0530")
Message-ID: <yq1mwgswm1v.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Reddy, Sreekanth <Sreekanth.Reddy@lsi.com> writes:

Sreekanth,

Sreekanth> The size of this contiguous block of memory pool is directly
Sreekanth> proportional to number of MSI-X vectors and the HBA queue
Sreekanth> depth. For example higher MSIX vectors requires larger
Sreekanth> contiguous block of memory pool.

Please also consider these patches that fix MSI-X issues on large
systems:

  http://marc.info/?l=linux-scsi&m=138879464506586

  http://marc.info/?l=linux-scsi&m=138879465206588

-- 
Martin K. Petersen	Oracle Linux Engineering
