Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab3A2KFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:05:33 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:49896 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751113Ab3A2KFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:05:31 -0500
Message-ID: <1359453928.1345.35.camel@x61.thuisdomein>
Subject: Re: [PATCH] aic7xxx_old: silence GCC warnings
From: Paul Bolle <pebolle@tiscali.nl>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 29 Jan 2013 11:05:28 +0100
In-Reply-To: <1351514716.1339.15.camel@x61.thuisdomein>
References: <1348219723.1581.5.camel@x61.thuisdomein>
	 <1351506978.1339.8.camel@x61.thuisdomein>
	 <1351513026.2480.4.camel@dabdike.sthat4.btopenzone.com>
	 <1351514716.1339.15.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 Jan 2013 10:05:28.0836 (UTC) FILETIME=[2A697440:01CDFE08]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 13:45 +0100, Paul Bolle wrote:
> On Mon, 2012-10-29 at 12:17 +0000, James Bottomley wrote:
> > mvsas has a maintainer: poke them harder
> 
> According to MAINTAINERS that's you. Is Xiangliang Yu perhaps the actual
> maintainer?

Building the mvsas driver triggers identical warnings in v3.8-rc5:
    drivers/scsi/mvsas/mv_sas.c: In function ‘mvs_update_phyinfo’:
    drivers/scsi/mvsas/mv_sas.c:1156:34: warning: comparison between ‘enum sas_device_type’ and ‘enum sas_dev_type’ [-Wenum-compare]
    drivers/scsi/mvsas/mv_sas.c:1159:39: warning: comparison between ‘enum sas_device_type’ and ‘enum sas_dev_type’ [-Wenum-compare]

And according to MAINTAINERS you're still the maintainer. So I'd guess
I'm poking the maintainer now.


Paul Bolle

