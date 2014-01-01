Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaAAOku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 09:40:50 -0500
Received: from ni.piap.pl ([195.187.100.4]:36512 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272AbaAAOkt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 09:40:49 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
References: <m38uv1uuzr.fsf@t19.piap.pl>
	<20131231112301.GC16456@n2100.arm.linux.org.uk>
Date: Wed, 01 Jan 2014 15:40:46 +0100
In-Reply-To: <20131231112301.GC16456@n2100.arm.linux.org.uk> (Russell King's
	message of "Tue, 31 Dec 2013 11:23:02 +0000")
MIME-Version: 1.0
Message-ID: <m3bnzvsr2p.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: Regression (ARM) arch/arm/mm/init.c doesn't build without CONFIG_ARM_PATCH_PHYS_VIRT.
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20131231 #7214915, check: 20140101 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> On Tue, Dec 31, 2013 at 12:20:56PM +0100, Krzysztof Hałasa wrote:
>> arch/arm/mm/init.c: In function 'setup_dma_zone':
>> arch/arm/mm/init.c:232:19: error: '__pv_phys_offset' undeclared (first use in this function)
>> 
>> Reverting the following commit fixes it:
>
> Already fixed long before Christmas.  Please use recent kernels.

Do you mean something other than Linus's tree? The problem I noted
is present in his tree as of Dec 30 - on both 3.13-rc6 and (then tip)
71ce176ee6ed1735b9a1160a5704a915d13849b1.

Or... do you mean the commit that added this regression?
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
