Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3DPHS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 03:18:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:33444 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755318Ab3DPHS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 03:18:57 -0400
Message-ID: <1366096361.24994.49.camel@pasglop>
Subject: Re: [PATCH v6 0/3] of/pci: Provide common support for PCI DT parsing
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Murray <Andrew.Murray@arm.com>,
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
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Michal Simek <monstr@monstr.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        suren.reddy@samsung.com
Date: Tue, 16 Apr 2013 09:12:41 +0200
In-Reply-To: <CACRpkdbSd8pRG5pUS0ymqXDSp=ZhoQa2ctVuRA0cCmUcX5qFAA@mail.gmail.com>
References: <1365693969-23907-1-git-send-email-Andrew.Murray@arm.com>
	 <20130415175641.GM28693@titan.lakedaemon.net>
	 <CACRpkdbSd8pRG5pUS0ymqXDSp=ZhoQa2ctVuRA0cCmUcX5qFAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 20:29 +0200, Linus Walleij wrote:
> > As agreed with Rob Herring, series applied to mvebu/drivers to
> support
> > mvebu pcie driver.
> 
> Will this hit ARM SoC soon-ish so I can base a pull request for the
> Integrator on this stuff as well?

Do not send this series upstream (or even in -next) until it has been at
least build-tested and acked by the affected architectures. AFAIK it
breaks microblaze build (simple missing #include) and isn't yet tested
on powerpc (I'm on vacation, maybe somebody else on linuxppc-dev can do
it though).

Ben.


