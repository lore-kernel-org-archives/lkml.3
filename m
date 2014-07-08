Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbaGHRSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:18:35 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45493 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527AbaGHRSc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:18:32 -0400
Date: Tue, 8 Jul 2014 18:18:28 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 0/9] Support for creating generic PCI host bridges
 from DT
Message-ID: <20140708171828.GM6501@e106497-lin.cambridge.arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <CAL_JsqK_CfagmiFOpOXVYGry22nGnCZL0ZXeJhYxb9zp=P2fsQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAL_JsqK_CfagmiFOpOXVYGry22nGnCZL0ZXeJhYxb9zp=P2fsQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 08 Jul 2014 17:18:29.0512 (UTC) FILETIME=[A2F8C080:01CF9AD0]
X-MC-Unique: 114070818183000901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2014 at 04:23:43PM +0100, Rob Herring wrote:
> On Tue, Jul 1, 2014 at 1:43 PM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > This is my resurected attempt at adding support for generic PCI host
> > bridge controllers that make use of device tree information to
> > configure themselves. I've tagged it as v8 although the patches
> > have now been reshuffled in order to ease adoption so referring to
> > the older versions might be a bit of a hoop jumping exercise.
> >
> > Changes from v7:
> >   - Reordered the patches so that fixes and non-controversial patches
> >     from v7 can be accepted more easily. If agreed I can split the
> >     series again into patches that can be upstreamed easily and ones
> >     that still need discussion.
> >   - Moved the of_create_host_bridge() function to drivers/of/of_pci.c
> >     to better reflect its target use.
> >   - Added the function to remap the bus I/O resources that used to be
> >     provided in my arm64 patch series and (re)named it pci_remap_iospace()
> >   - Removed error code checking from parsing and mapping of IRQ from DT
> >     in recognition that some PCI devices will not have legacy IRQ mappings.
> >
> > v7 thread here with all the historic information: https://lkml.org/lkml/2014/3/14/279
> 
> Can you publish a branch for this series please.
> 
> Rob
> 

Hi Rob,

I have pushed a brach that matches my v8 patchset +1 obvious missing header include
here: http://www.linux-arm.org/git?p=linux-ld.git;a=shortlog;h=refs/heads/for-upstream/pci_v8

Best regards,
Liviu


-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

