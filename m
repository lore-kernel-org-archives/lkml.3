Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab3G2O0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:26:50 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33299 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3G2O0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:26:49 -0400
To: Nick Alcock <nix@esperi.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        nick.cheng@areca.com.tw
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup / early userspace transition
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <87r4ehfzhf.fsf@spindle.srvr.nix>
Date: Mon, 29 Jul 2013 10:26:36 -0400
In-Reply-To: <87r4ehfzhf.fsf@spindle.srvr.nix> (Nick Alcock's message of "Mon,
	29 Jul 2013 11:10:36 +0100")
Message-ID: <yq11u6hl9wj.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Nick" == Nick Alcock <nix@esperi.org.uk> writes:

Nick> My server's ARC-1210 has been working fine for years, but when I
Nick> upgraded from 3.10.1, it started failing:

Nick> [ 0.784044] Areca RAID Controller0: F/W V1.46 2009-01-06 & Model
Nick> ARC-1210 [ 0.804028] scsi0 : Areca SATA Host Adapter RAID
Nick> Controller
Nick>  Driver Version 1.20.00.15 2010/08/05
Nick> [...]

Interesting. Please provide the output of:

# sg_inq /dev/sdd
# sg_vpd /dev/sdd
# sg_vpd -p ai /dev/sdd

-- 
Martin K. Petersen	Oracle Linux Engineering
