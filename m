Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab3LaLXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 06:23:10 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:52678 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752630Ab3LaLXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 06:23:08 -0500
Date: Tue, 31 Dec 2013 11:23:02 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: Regression (ARM) arch/arm/mm/init.c doesn't build without
	CONFIG_ARM_PATCH_PHYS_VIRT.
Message-ID: <20131231112301.GC16456@n2100.arm.linux.org.uk>
References: <m38uv1uuzr.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m38uv1uuzr.fsf@t19.piap.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 31, 2013 at 12:20:56PM +0100, Krzysztof Hałasa wrote:
> arch/arm/mm/init.c: In function 'setup_dma_zone':
> arch/arm/mm/init.c:232:19: error: '__pv_phys_offset' undeclared (first use in this function)
> 
> Reverting the following commit fixes it:

Already fixed long before Christmas.  Please use recent kernels.
