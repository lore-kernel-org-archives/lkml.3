Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbaIRF4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 01:56:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56238 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458AbaIRF4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 01:56:08 -0400
Date: Thu, 18 Sep 2014 07:55:53 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'Will Deacon'" <will.deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-msm@vger.kernel.org'" <linux-arm-msm@vger.kernel.org>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] arm:extend the reserved mrmory for initrd to be page
 aligned
Message-ID: <20140918055553.GO3755@pengutronix.de>
References: <35FD53F367049845BC99AC72306C23D103D6DB491616@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35FD53F367049845BC99AC72306C23D103D6DB491616@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

just some commit log nit picking:

$Subject ~= s/mrmory/memory/

And also "ARM: " is the more typical prefix. Don't know if there is a
best practice for patches touching both arm and arm64. (But assuming
this will go through Russell's patch tracker this doesn't matter much.)

On Thu, Sep 18, 2014 at 09:58:10AM +0800, Wang, Yalin wrote:
> this patch extend the start and end address of initrd to be page aligned,
This patch extends ...

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
