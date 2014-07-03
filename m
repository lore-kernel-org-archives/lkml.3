Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbaGCTsC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 15:48:02 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:56197 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaGCTsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 15:48:00 -0400
Date: Thu, 3 Jul 2014 19:47:59 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Roger Quadros <rogerq@ti.com>
cc: tony@atomide.com, rnayak@ti.com, kishon@ti.com, george.cherian@ti.com,
        balbi@ti.com, balajitk@ti.com, nsekhar@ti.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ARM: DRA7: hwmod: Fixup SATA hwmod
In-Reply-To: <1404385274-5093-3-git-send-email-rogerq@ti.com>
Message-ID: <alpine.DEB.2.02.1407031947380.1515@utopia.booyaka.com>
References: <1404385274-5093-1-git-send-email-rogerq@ti.com> <1404385274-5093-3-git-send-email-rogerq@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2014, Roger Quadros wrote:

> Get rid of optional clock as that is now managed by the
> AHCI platform driver.
> 
> Correct .mpu_rt_idx to 1 as the module register space (SYSCONFIG..)
> is passed as the second memory resource in the device tree.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Reviewed-by: Rajendra Nayak <rnayak@ti.com>
> Tested-by: Sekhar Nori <nsekhar@ti.com>

Thanks, this looks like a fix, so, queueing for v3.16-rc.


- Paul
