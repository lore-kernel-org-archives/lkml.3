Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935325Ab3BOEwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 23:52:23 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:57667 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932784Ab3BOEwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 23:52:21 -0500
Date: Fri, 15 Feb 2013 05:52:17 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Andrew Murray <andrew.murray@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] of/pci: Provide support for parsing PCI DT ranges
 property
Message-ID: <20130215055217.5693dd08@skate>
In-Reply-To: <20130214191745.GA13875@avionic-0098.mockup.avionic-design.de>
References: <1360570940-17086-1-git-send-email-thierry.reding@avionic-design.de>
	<1360570940-17086-2-git-send-email-thierry.reding@avionic-design.de>
	<20130213225311.37FFB3E3557@localhost>
	<20130214165341.GA29199@arm.com>
	<20130214191745.GA13875@avionic-0098.mockup.avionic-design.de>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, 14 Feb 2013 20:17:45 +0100, Thierry Reding wrote:
> On Thu, Feb 14, 2013 at 04:53:41PM +0000, Andrew Murray wrote:
> > Thierry,
> > 
> > If you don't have much bandwidth I'd be quite happy to take this on - this
> > would be beneficial for my eventual patchset. I can start by refactoring common
> > implementations of pci_process_bridge_OF_ranges or similar across the
> > architectures as per Grant's suggestion? I didn't do this when I first posted
> > the patch as I was concerned about the testing effort.
> 
> Absolutely! Since it was your patch in the first place you're just as
> well suited to do this if you want to and have the time.

And I'll be more than happy to test your patches in the context of the
Marvell PCIe driver.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
