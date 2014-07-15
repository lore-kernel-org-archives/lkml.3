Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbaGOR7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:59:31 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30592 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbaGOR73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:59:29 -0400
To: "Reddy\, Sreekanth" <Sreekanth.Reddy@avagotech.com>
Cc: <jejb@kernel.org>, <JBottomley@Parallels.com>,
        <linux-scsi@vger.kernel.org>, <Sathya.Prakash@avagotech.com>,
        <Nagalakshmi.Nandigama@avagotech.com>, <linux-kernel@vger.kernel.org>,
        <hch@infradead.org>, <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH 08/10][SCSI]mpt2sas: Get IOC_FACTS information using handshake protocol only after HBA card gets into READY or Operational state
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20140625103532.GA12953@avagotech.com>
Date: Tue, 15 Jul 2014 13:58:57 -0400
In-Reply-To: <20140625103532.GA12953@avagotech.com> (Sreekanth Reddy's message
	of "Wed, 25 Jun 2014 16:05:32 +0530")
Message-ID: <yq1wqbetsf2.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Reddy, Sreekanth <Sreekanth.Reddy@avagotech.com> writes:

Sreekanth> The driver would send IOC facts only if HBA is in operational
Sreekanth> or ready state. If it is in fault state, a diagnostic reset
Sreekanth> would be issued. It would wait for 10 seconds to exit out of
Sreekanth> reset state. If the HBA continues to be in reset state, then
Sreekanth> the HBA wouldn't be claimed by the driver.

Your patch header describes what used to happen. What does the patched
code do?

Also, several of your patches move large functions around within the
file. That makes it really hard to figure out what the actual code
changes are. Please split changes like that in two: One patch that moves
stuff around in bulk without any functional changes and a second that
addresses the issue at hand. That makes reviewing much easier.

-- 
Martin K. Petersen	Oracle Linux Engineering
