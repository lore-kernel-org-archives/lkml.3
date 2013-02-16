Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab3BPVoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 16:44:39 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:4616 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578Ab3BPVoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 16:44:38 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Subject: Re: [PATCH 1/2] tg3: Remove define and single use of
 GET_CHIP_REV_ID
From: "Michael Chan" <mchan@broadcom.com>
To: "Joe Perches" <joe@perches.com>
cc: "Matt Carlson" <mcarlson@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <dea1c655b2c1380821aae6cd8438ad742ddf6e12.1361049158.git.joe@perches.com>
References: <dea1c655b2c1380821aae6cd8438ad742ddf6e12.1361049158.git.joe@perches.com>
Date: Sat, 16 Feb 2013 13:44:24 -0800
Message-ID: <1361051064.2240.2.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7D0123EC3QG2465649-01-01
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-02-16 at 13:20 -0800, Joe Perches wrote:
> It's the same value as tp->pci_chip_rev_id so use that
> instead.  This makes all CHIPREV_ID_<foo> tests the same.
> 
> Signed-off-by: Joe Perches <joe@perches.com> 

Acked-by: Michael Chan <mchan@broadcom.com>


