Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab3GaDUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 23:20:17 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17889 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab3GaDUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 23:20:13 -0400
To: Nick Alcock <nick.alcock@esperi.org.uk>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, nick.cheng@areca.com.tw,
        stable@vger.kernel.org
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup / early userspace transition
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm>
	<87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm>
	<87fvuxdqes.fsf@spindle.srvr.nix> <yq1txjdhree.fsf@sermon.lab.mkp.net>
	<51F80167.1080004@fastmail.fm> <87siyvlhgs.fsf@spindle.srvr.nix>
Date: Tue, 30 Jul 2013 23:19:59 -0400
In-Reply-To: <87siyvlhgs.fsf@spindle.srvr.nix> (Nick Alcock's message of "Wed,
	31 Jul 2013 01:07:47 +0100")
Message-ID: <yq1vc3rh0v4.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Nick" == Nick Alcock <nick.alcock@esperi.org.uk> writes:

Nick> in which case we don't actually know that your Areca controller
Nick> supports the VPD page we thought it did: quite possibly only this
Nick> underlying disk does.

The ATA Information VPD page is created by the SCSI-ATA Translation
layer. The controller firmware in this case.

-- 
Martin K. Petersen	Oracle Linux Engineering
