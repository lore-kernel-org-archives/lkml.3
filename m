Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab3BRRqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 12:46:20 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47695 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647Ab3BRRqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:46:19 -0500
Date: Mon, 18 Feb 2013 12:46:17 -0500 (EST)
Message-Id: <20130218.124617.418052148242224119.davem@davemloft.net>
To: mchan@broadcom.com
Cc: joe@perches.com, mcarlson@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tg3: Remove define and single use of
 GET_CHIP_REV_ID
From: David Miller <davem@davemloft.net>
In-Reply-To: <1361051064.2240.2.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
References: <dea1c655b2c1380821aae6cd8438ad742ddf6e12.1361049158.git.joe@perches.com>
	<1361051064.2240.2.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael Chan" <mchan@broadcom.com>
Date: Sat, 16 Feb 2013 13:44:24 -0800

> On Sat, 2013-02-16 at 13:20 -0800, Joe Perches wrote:
>> It's the same value as tp->pci_chip_rev_id so use that
>> instead.  This makes all CHIPREV_ID_<foo> tests the same.
>> 
>> Signed-off-by: Joe Perches <joe@perches.com> 
> 
> Acked-by: Michael Chan <mchan@broadcom.com>

Applied.
