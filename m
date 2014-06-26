Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbaFZOLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 10:11:52 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:23616 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750755AbaFZOLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 10:11:50 -0400
Date: Thu, 26 Jun 2014 15:11:38 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-pci <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH v7 1/6] pci: Introduce pci_register_io_range() helper
 function.
Message-ID: <20140626141138.GC15296@arm.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
 <20140405001953.GE15806@google.com>
 <20140407083120.GE17163@e106497-lin.cambridge.arm.com>
 <5183143.FxBNM0xTAV@wuerfel>
 <CAErSpo4iEV6khP63ZTF+YUTKi9WLFXzMv13nxw15y3qDg15Ztg@mail.gmail.com>
 <20140626085926.GB11244@arm.com>
 <20140626093029.GB12812@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626093029.GB12812@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 10:30:29AM +0100, Liviu Dudau wrote:
> On Thu, Jun 26, 2014 at 09:59:26AM +0100, Catalin Marinas wrote:
> > Although a bit late, I'm raising this now and hopefully we'll come to a
> > conclusion soon. Delaying arm64 PCIe support even further is not a real
> > option, which leaves us with:
> > 
> > 1. Someone else (with enough PCIe knowledge) volunteering to take over
> >    soon or
> > 2. Dropping Liviu's work and going for an arm64-specific implementation
> >    (most likely based on the arm32 implementation, see below)
[...]
> > In conclusion, unless someone volunteers for the first option fairly
> > soon, we'll post the alternative patches for review and take it from
> > there.
> 
> That would be a huge step backwards IMO and a huge dissapointment. If
> you go with the alternative patches from Will you will basically reset
> every partner's implementation that has been built on top of my
> patches (when they did so with the understanding that my series will be
> the one ARM will support and publish) *and* make anyone's attempt to
> create a generic implementation harder, as they will have to undo this
> code to remove the arch-specific parts.

I fully agree and the alternative patchset is definitely _not_ my
preferred solution. You can read this email as a request for help to
complete the work (whether it comes from ARM, Linaro or other interested
parties). I don't mean taking over the whole patchset but potentially
helping with other arch conversion (microblaze, arm multi-platform).

(however, if the generic PCIe work won't happen in reasonable time, we
need to set some deadline rather than keeping the patchset out of tree
indefinitely)

-- 
Catalin
