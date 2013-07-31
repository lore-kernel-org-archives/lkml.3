Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab3GaDQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 23:16:11 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19674 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab3GaDQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 23:16:09 -0400
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Nix <nix@esperi.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, nick.cheng@areca.com.tw,
        stable@vger.kernel.org
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup / early userspace transition
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm>
	<87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm>
	<87fvuxdqes.fsf@spindle.srvr.nix> <yq1txjdhree.fsf@sermon.lab.mkp.net>
	<51F80167.1080004@fastmail.fm>
Date: Tue, 30 Jul 2013 23:15:53 -0400
In-Reply-To: <51F80167.1080004@fastmail.fm> (Bernd Schubert's message of "Tue,
	30 Jul 2013 20:09:43 +0200")
Message-ID: <yq1zjt3h11y.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Bernd" == Bernd Schubert <bernd.schubert@fastmail.fm> writes:

Bernd,

>> Product revision level: R001 

It's clearly not verbatim passthrough...

Bernd> Besides the firmware, the difference might be that I'm exporting
Bernd> single disks without any areca-raidset in between.  I can try to
Bernd> confirm that tomorrow, I just need the system as it is till
Bernd> tomorrow noon.

That would be a great data point. I don't have any Areca boards.

-- 
Martin K. Petersen	Oracle Linux Engineering
