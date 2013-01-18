Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332Ab3ARIpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 03:45:00 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:35710 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab3ARIo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 03:44:58 -0500
MIME-Version: 1.0
In-Reply-To: <1358449457.4596.64.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
References: <CAMXyS3Mvc8SkJxu4fCcUn+XpNcHrzEQ=M5w2eenVr-YKwa3AEQ@mail.gmail.com>
	<CAMXyS3MRx3D__60xtt4G4CCyHSTW2iHd1x1AR1LCQkrZrOiJ2g@mail.gmail.com>
	<CAD9gYJL1GjZtPuEWozmgM37NzhJeAO1Oe69Tnzxi5bCPMijmcA@mail.gmail.com>
	<1357703565.7140.217.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
	<CAMXyS3PhStKo_xeiTRH+kbZXNUcwmMvrvTHrDOR-6qkuUCVH2A@mail.gmail.com>
	<1358206365.4596.23.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
	<CAMXyS3PBAOraPTYRW9BSmoccVWAuY0RzZNgKe-L4Z3WHQDDgbA@mail.gmail.com>
	<1358449457.4596.64.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
Date: Fri, 18 Jan 2013 09:44:57 +0100
Message-ID: <CAMXyS3N49hjWtJEkPKm3bgGqr7LfHEcNzPUBh-VO9gRxjq6axQ@mail.gmail.com>
Subject: Re: tg3 v3.123 in 100Mbps Full-Duplex mode with autoneg off
From: Marcin Miotk <marcinmiotk81@gmail.com>
To: Michael Chan <mchan@broadcom.com>
Cc: =?UTF-8?B?546L6YeR5rWm?= <jinpuwang@gmail.com>, nsujir@broadcom.com,
        Benjamin Li <benli@broadcom.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There apparently has been a change in behavior in the tg3 code, but
> again it should not matter.  The 3.7 kernel that I tested on behaved the
> same as your non-working case but it worked for me.  I guess I can try
> to restore the original behavior.  I'll need time to look through all
> the changes.

Thanks a lot for that, I will look forward for the results of your
investigation.

Regards,
Marcin
