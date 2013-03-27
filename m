Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab3C0Mzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 08:55:44 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:59607 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3C0Mzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:55:42 -0400
Date: Wed, 27 Mar 2013 13:55:37 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Andrew Murray <Andrew.Murray@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-pci@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH v2] of/pci: Provide support for parsing PCI DT
 ranges property
Message-ID: <20130327135537.52da5818@skate>
In-Reply-To: <CACRpkdZ_iuz96JWjHcr+6ugRY29MPA-wiGWtQQJqk30iTQE--Q@mail.gmail.com>
References: <20130221154709.GA26660@arm.com>
	<20130320210521.65261e77@skate>
	<CACRpkdZ_iuz96JWjHcr+6ugRY29MPA-wiGWtQQJqk30iTQE--Q@mail.gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linus Walleij,

On Wed, 27 Mar 2013 13:50:09 +0100, Linus Walleij wrote:

> > Would it be possible to get this patch merged for 3.10, or get some
> > review comments that would allow us to rework it in time for 3.10 ?
> 
> Thomas can you supply a Reviewed-by/Tested-by tag?
> That certainly helps...

Yes, I'm planning on testing RFC v3 from Andrew right now, and send a
new version of the Marvell PCIe patch set that includes it. If all goes
well, should happen this afternoon.

Thanks,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
