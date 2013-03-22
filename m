Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3CVJtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 05:49:22 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:58173 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab3CVJtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 05:49:21 -0400
Date: Fri, 22 Mar 2013 10:49:17 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Andrew Murray <andrew.murray@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [RFC PATCH RESEND v2] of/pci: Provide support for parsing PCI
 DT ranges property
Message-ID: <20130322104917.78e98b93@skate>
In-Reply-To: <20130322093936.GA875@arm.com>
References: <1362140616-19346-1-git-send-email-Andrew.Murray@arm.com>
	<20130321170625.2a1bf226@skate>
	<20130322093936.GA875@arm.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Fri, 22 Mar 2013 09:39:36 +0000, Andrew Murray wrote:

> > Thanks, I've tested this successfully with the Marvell PCIe driver. I'm
> > about to send a new version of the Marvell PCIe patch set that includes
> > this RFC proposal.
> > 
> > I only made two small changes compared to your version, detailed below.
> 
> Thanks for the feedback, all looks good to me. Do I need to give ack?

If you could ack the version I sent in the PCIe patch set yesterday, it
would be great yes.

I'm hoping also that Grant will have a look at this and say if he
agrees. The entire PCIe patch set depends on this patch, so if any
rework of this OF patch needs to be done, it'd be great to know it
sooner rather than later.

Thanks!

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
