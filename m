Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab3DPLbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 07:31:47 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:52304 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3DPLbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 07:31:45 -0400
Date: Tue, 16 Apr 2013 13:31:40 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Murray <Andrew.Murray@arm.com>,
        Rob Herring <rob.herring@calxeda.com>, siva.kallam@samsung.com,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>, Liviu.Dudau@arm.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Paul Mackerras <paulus@samba.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jingoo Han <jg1.han@samsung.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Michal Simek <monstr@monstr.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        suren.reddy@samsung.com
Subject: Re: [PATCH v6 0/3] of/pci: Provide common support for PCI DT
 parsing
Message-ID: <20130416133140.7de24c89@skate>
In-Reply-To: <20130416112951.GZ28693@titan.lakedaemon.net>
References: <1365693969-23907-1-git-send-email-Andrew.Murray@arm.com>
	<20130415175641.GM28693@titan.lakedaemon.net>
	<CACRpkdbSd8pRG5pUS0ymqXDSp=ZhoQa2ctVuRA0cCmUcX5qFAA@mail.gmail.com>
	<1366096361.24994.49.camel@pasglop>
	<20130416112951.GZ28693@titan.lakedaemon.net>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jason Cooper,

On Tue, 16 Apr 2013 07:29:51 -0400, Jason Cooper wrote:

> > Do not send this series upstream (or even in -next) until it has been at
> > least build-tested and acked by the affected architectures. AFAIK it
> > breaks microblaze build (simple missing #include) and isn't yet tested
> > on powerpc (I'm on vacation, maybe somebody else on linuxppc-dev can do
> > it though).
> 
> I added the missing include reference by Michal Simek for the branch at
> mvebu/drivers.

Some other build issues were reported on x86 during the night (thanks
to automated build tests), and Andrew Murray has just sent a new
version v7 of the patch set addressing those issues, as well as the
missing include.

Also, please note that Andrew's patch set contains three patches, but
the Marvell PCIe driver only requires PATCH 1/3 and PATCH 2/3.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
