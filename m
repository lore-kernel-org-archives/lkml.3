Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab3APL1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 06:27:48 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47629 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab3APL1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 06:27:46 -0500
Date: Wed, 16 Jan 2013 11:25:56 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 05/14] lib: Add I/O map cache implementation
Message-ID: <20130116112556.GR23505@n2100.arm.linux.org.uk>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <20130109231758.GA27065@obsidianresearch.com> <20130110071937.GG15212@avionic-0098.adnet.avionic-design.de> <201301100917.19577.arnd@arndb.de> <20130110102544.GA5546@avionic-0098.adnet.avionic-design.de> <20130110182007.GA28004@obsidianresearch.com> <20130110185505.GA22944@avionic-0098.adnet.avionic-design.de> <20130110190327.GA23110@avionic-0098.adnet.avionic-design.de> <20130110192417.GA18478@obsidianresearch.com> <20130116101822.GA17706@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116101822.GA17706@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 11:18:22AM +0100, Thierry Reding wrote:
> 		err = ioremap_page_range(virt, virt + SZ_64K - 1, phys,

Why -1 here?
