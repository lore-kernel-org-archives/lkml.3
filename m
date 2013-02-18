Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab3BRJid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 04:38:33 -0500
Received: from service87.mimecast.com ([91.220.42.44]:53430 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3BRJic convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 04:38:32 -0500
Date: Mon, 18 Feb 2013 09:38:28 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] of/pci: Provide support for parsing PCI DT ranges
 property
Message-ID: <20130218093828.GA26245@arm.com>
References: <1360570940-17086-1-git-send-email-thierry.reding@avionic-design.de>
 <1360570940-17086-2-git-send-email-thierry.reding@avionic-design.de>
 <20130213225311.37FFB3E3557@localhost>
 <20130214165341.GA29199@arm.com>
 <20130214191745.GA13875@avionic-0098.mockup.avionic-design.de>
 <CACRpkdYbzuONVyUZ5V9t5D6nux9G9p1QRS+w7AO-cFZFBGMRFA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACRpkdYbzuONVyUZ5V9t5D6nux9G9p1QRS+w7AO-cFZFBGMRFA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Feb 2013 09:38:29.0005 (UTC) FILETIME=[B52DDBD0:01CE0DBB]
X-MC-Unique: 113021809383001701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 01:16:17PM +0000, Linus Walleij wrote:
> n Thu, Feb 14, 2013 at 8:17 PM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> > On Thu, Feb 14, 2013 at 04:53:41PM +0000, Andrew Murray wrote:
> >> Thierry,
> >>
> >> If you don't have much bandwidth I'd be quite happy to take this on - this
> >> would be beneficial for my eventual patchset. I can start by refactoring common
> >> implementations of pci_process_bridge_OF_ranges or similar across the
> >> architectures as per Grant's suggestion? I didn't do this when I first posted
> >> the patch as I was concerned about the testing effort.
> >
> > Absolutely! Since it was your patch in the first place you're just as
> > well suited to do this if you want to and have the time.
> 
> I am working on device tree patches for the Integrator/AP with it's
> PCIv3 bridge, and I also follow this with great interest. I was almost
> going to start the copy/paste cycle but now I think it's better if
> I wait for this to happen.

No problem - I am currently looking at this.

Andrew Murray

