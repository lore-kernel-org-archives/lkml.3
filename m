Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbaAHGkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 01:40:33 -0500
Received: from ni.piap.pl ([195.187.100.4]:43104 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbaAHGkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 01:40:24 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <m38uv1uuzr.fsf@t19.piap.pl> <m3ha9gx63v.fsf@t19.piap.pl>
	<20140106223906.GH27432@n2100.arm.linux.org.uk>
	<52CB3F55.1050404@ti.com>
	<20140107011121.GI27432@n2100.arm.linux.org.uk>
	<52CC3D46.3090102@ti.com>
	<20140107175505.GK27432@n2100.arm.linux.org.uk>
Date: Wed, 08 Jan 2014 07:40:21 +0100
In-Reply-To: <20140107175505.GK27432@n2100.arm.linux.org.uk> (Russell King's
	message of "Tue, 7 Jan 2014 17:55:06 +0000")
MIME-Version: 1.0
Message-ID: <m361pvt1re.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: Regression (ARM) arch/arm/mm/init.c doesn't build without CONFIG_ARM_PATCH_PHYS_VIRT.
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20140108 #7268375, check: 20140108 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> Okay, reverted.

Thanks.
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
