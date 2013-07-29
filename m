Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab3G2XfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 19:35:01 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30088 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab3G2Xe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 19:34:59 -0400
To: Nix <nix@esperi.org.uk>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        nick.cheng@areca.com.tw, stable@vger.kernel.org
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup / early userspace transition
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm>
	<87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm>
	<87fvuxdqes.fsf@spindle.srvr.nix>
Date: Mon, 29 Jul 2013 19:34:33 -0400
In-Reply-To: <87fvuxdqes.fsf@spindle.srvr.nix> (nix@esperi.org.uk's message of
	"Mon, 29 Jul 2013 22:09:31 +0100")
Message-ID: <yq1txjdhree.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Nix" == Nix  <nix@esperi.org.uk> writes:

Bernd,

Nix> I can now confirm that reverting this commit causes this problem to
Nix> go away, and my machine boots fine again.

Can you please send me the output of sq_inq with your 1.49 firmware?

I made a tweak that allowed Nix to boot but we're trying to find a good
blacklist trigger. And that's tricky given that Areca allows you
manually specify the SCSI model string for each volume...

-- 
Martin K. Petersen	Oracle Linux Engineering
