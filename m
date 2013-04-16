Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934953Ab3DPLht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 07:37:49 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:36714 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934393Ab3DPLhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 07:37:47 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX194PAtMCJ4IMvESfNgh7HZRzBWJtXVVf58=
Date: Tue, 16 Apr 2013 07:37:27 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
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
Message-ID: <20130416113727.GA28693@titan.lakedaemon.net>
References: <1365693969-23907-1-git-send-email-Andrew.Murray@arm.com>
 <20130415175641.GM28693@titan.lakedaemon.net>
 <CACRpkdbSd8pRG5pUS0ymqXDSp=ZhoQa2ctVuRA0cCmUcX5qFAA@mail.gmail.com>
 <1366096361.24994.49.camel@pasglop>
 <20130416112951.GZ28693@titan.lakedaemon.net>
 <20130416133140.7de24c89@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416133140.7de24c89@skate>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 01:31:40PM +0200, Thomas Petazzoni wrote:
> Dear Jason Cooper,
> 
> On Tue, 16 Apr 2013 07:29:51 -0400, Jason Cooper wrote:
> 
> > > Do not send this series upstream (or even in -next) until it has been at
> > > least build-tested and acked by the affected architectures. AFAIK it
> > > breaks microblaze build (simple missing #include) and isn't yet tested
> > > on powerpc (I'm on vacation, maybe somebody else on linuxppc-dev can do
> > > it though).
> > 
> > I added the missing include reference by Michal Simek for the branch at
> > mvebu/drivers.
> 
> Some other build issues were reported on x86 during the night (thanks
> to automated build tests), and Andrew Murray has just sent a new
> version v7 of the patch set addressing those issues, as well as the
> missing include.
> 
> Also, please note that Andrew's patch set contains three patches, but
> the Marvell PCIe driver only requires PATCH 1/3 and PATCH 2/3.

Ok.  Thanks Andrew!  Do you (AndrewM) want me to keep the series
together?  Or drop 3/3 from my tree?  I can do either, I just need to
know.

thx,

Jason.
