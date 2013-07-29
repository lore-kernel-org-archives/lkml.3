Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab3G2O1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:27:40 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33810 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab3G2O1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:27:38 -0400
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Nick Alcock <nix@esperi.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        nick.cheng@areca.com.tw
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup / early userspace transition
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm>
Date: Mon, 29 Jul 2013 10:27:23 -0400
In-Reply-To: <51F667C2.4020801@fastmail.fm> (Bernd Schubert's message of "Mon,
	29 Jul 2013 15:01:54 +0200")
Message-ID: <yq1wqo9jvas.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Bernd" == Bernd Schubert <bernd.schubert@fastmail.fm> writes:

Bernd> I tested this patch with ARC-1260 and F/W V1.49, no issues. 

It could be due to the firmware version discrepancy.

-- 
Martin K. Petersen	Oracle Linux Engineering
