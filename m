Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbbAMU5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:57:05 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:41818 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbbAMU5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:57:02 -0500
Date: Tue, 13 Jan 2015 15:56:57 -0500
From: Tejun Heo <tj@kernel.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: linux-ide@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: pata_at91: depend on !ARCH_MULTIPLATFORM
Message-ID: <20150113205657.GF9489@htj.dyndns.org>
References: <1421173517-21246-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421173517-21246-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 07:25:17PM +0100, Alexandre Belloni wrote:
> Until the driver is corrected to stop using mach/at91isam9_smc.h, it won't
> compile in a ARCH_MULTIPLATFORM configuration.
> 
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Applied to libata/for-3.19-fixes.

Thanks.

-- 
tejun
