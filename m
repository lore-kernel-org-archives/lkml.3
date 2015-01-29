Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbbA2G3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:29:24 -0500
Received: from ni.piap.pl ([195.187.100.4]:42160 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbbA2G3X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:29:23 -0500
X-Greylist: delayed 753 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jan 2015 01:29:22 EST
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Rob Herring <robh@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
	<1420857290-8373-7-git-send-email-robh@kernel.org>
Date: Thu, 29 Jan 2015 07:16:47 +0100
In-Reply-To: <1420857290-8373-7-git-send-email-robh@kernel.org> (Rob Herring's
	message of "Fri, 9 Jan 2015 20:34:40 -0600")
MIME-Version: 1.0
Message-ID: <m37fw6xga8.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH 06/16] ARM: cns3xxx: convert PCI to use generic config accesses
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20140401 #7726142, check: 20150129 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Herring <robh@kernel.org> writes:

> Convert the cns3xxx PCI driver to use the generic config access functions.
>
> This changes accesses from __raw_readl/__raw_writel to readl/writel.
>
>  arch/arm/mach-cns3xxx/pcie.c | 52 +++++++++-----------------------------------

This looks fine:
Acked-by: Krzysztof Hałasa <khalasa@piap.pl>

-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
