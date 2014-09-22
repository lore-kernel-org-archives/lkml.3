Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaIVNhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 09:37:03 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49568 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaIVNhA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 09:37:00 -0400
Date: Mon, 22 Sep 2014 14:36:55 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v9 06/12] ARM: integrator: Correct usage of
 of_pci_range_to_resource()
Message-ID: <20140922133655.GR1994@e106497-lin.cambridge.arm.com>
References: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
 <1407860725-25202-7-git-send-email-Liviu.Dudau@arm.com>
 <CACRpkdanh8vb2-jxVvhmYLXEcvaEKv+BCiom8sPkT3uX_dhG6g@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACRpkdanh8vb2-jxVvhmYLXEcvaEKv+BCiom8sPkT3uX_dhG6g@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 22 Sep 2014 13:36:56.0885 (UTC) FILETIME=[4757D650:01CFD66A]
X-MC-Unique: 114092214365703001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 01:47:16PM +0100, Linus Walleij wrote:
> On Tue, Aug 12, 2014 at 6:25 PM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> 
> > Previously, of_pci_range_to_resource() would return a resource
> > that contained physical addresses of the IO space even if the
> > IORESOURCE_IO flags mandate a logical port set of values. Now
> > that the function has been fixed we need to update the drivers
> > that were taking advantage of the old behaviour.
> >
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> 
> I guess you know what you're doing so:

I hope so :)

> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks!

> 
> I expect this patch to go through the PCI tree or so? Or do you
> expect me to funnel it?

It will go through PCI tree together with the patch that "fixes"
the existing functionality.

Best regards,
Liviu 

> 
> Yours,
> Linus Walleij
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

