Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab3ANXnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 18:43:11 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:2481 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757089Ab3ANXnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 18:43:10 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Subject: Re: tg3 v3.123 in 100Mbps Full-Duplex mode with autoneg off
From: "Michael Chan" <mchan@broadcom.com>
To: "Marcin Miotk" <marcinmiotk81@gmail.com>
cc: =?UTF-8?Q?=E7=8E=8B=E9=87=91=E6=B5=A6?= <jinpuwang@gmail.com>,
        nsujir@broadcom.com, "Benjamin Li" <benli@broadcom.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CAMXyS3PhStKo_xeiTRH+kbZXNUcwmMvrvTHrDOR-6qkuUCVH2A@mail.gmail.com>
References: <CAMXyS3Mvc8SkJxu4fCcUn+XpNcHrzEQ=M5w2eenVr-YKwa3AEQ@mail.gmail.com>
 <CAMXyS3MRx3D__60xtt4G4CCyHSTW2iHd1x1AR1LCQkrZrOiJ2g@mail.gmail.com>
 <CAD9gYJL1GjZtPuEWozmgM37NzhJeAO1Oe69Tnzxi5bCPMijmcA@mail.gmail.com>
 <1357703565.7140.217.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
 <CAMXyS3PhStKo_xeiTRH+kbZXNUcwmMvrvTHrDOR-6qkuUCVH2A@mail.gmail.com>
Date: Mon, 14 Jan 2013 15:32:45 -0800
Message-ID: <1358206365.4596.23.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7CEA481E1ZS6768091-01-01
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-09 at 08:03 +0100, Marcin Miotk wrote:
> 03:04.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5715
> Gigabit Ethernet (rev a3)
> 03:04.1 Ethernet controller: Broadcom Corporation NetXtreme BCM5715
> Gigabit Ethernet (rev a3) 

I tested on 3.7 kernel and it seemed to work.  Bear in mind that you'll
lose auto MDI-X when both sides don't autoneg.  Please provide the
following:

1. ethtool eth0 with a working kernel.  I'd like to see the MDI-X
setting when it is working.

2. mii-tool -vvv eth0 with the non-working kernel.

Thanks.


