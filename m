Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab3G2UPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 16:15:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33241 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab3G2UPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 16:15:45 -0400
To: Nix <nix@esperi.org.uk>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        nick.cheng@areca.com.tw
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup / early userspace transition
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm>
	<87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm>
	<87d2q1dteu.fsf@spindle.srvr.nix>
Date: Mon, 29 Jul 2013 16:15:27 -0400
In-Reply-To: <87d2q1dteu.fsf@spindle.srvr.nix> (nix@esperi.org.uk's message of
	"Mon, 29 Jul 2013 21:04:41 +0100")
Message-ID: <yq138qxjf6o.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Nix" == Nix  <nix@esperi.org.uk> writes:

Nix> spindle:/boot# sg_vpd --page=0x89 /dev/sda ATA information VPD
Nix> page: fetching VPD page failed

Please add -v

I'll also need the output of:

# sg_vpd -vl


Nix> I'll try rebooting into a kernel with that commit reverted next.

Doesn't matter as far as the sg commands are concerned...

-- 
Martin K. Petersen	Oracle Linux Engineering
