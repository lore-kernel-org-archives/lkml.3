Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab3GKUCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 16:02:46 -0400
Received: from sous-sol.org ([216.99.217.87]:49331 "EHLO sequoia2.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751050Ab3GKUCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 16:02:44 -0400
Date: Thu, 11 Jul 2013 12:00:54 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Chris Wright <chrisw@sous-sol.org>, Bjorn Helgaas <bhelgaas@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>
Subject: Re: WARNING: at drivers/iommu/dmar.c:484 warn_invalid_dmar with
 Intel Motherboard
Message-ID: <20130711190054.GC24833@sequoia2.sous-sol.org>
References: <20130709202406.GA11867@roeck-us.net>
 <CAErSpo6Ma1TnBP-UGGhWFN1rj48y+yTS=VmVw_s30_FWgjfdpg@mail.gmail.com>
 <20130709223106.GA16429@roeck-us.net>
 <20130709232252.GB2676@sequoia2.sous-sol.org>
 <20130709234331.GA10833@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709234331.GA10833@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Guenter Roeck (linux@roeck-us.net) wrote:
> On Tue, Jul 09, 2013 at 04:22:52PM -0700, Chris Wright wrote:
> > One thing I've seen is the BIOS zeroing the base register address when
> > VT-d is disabled in BIOS.  So, Guenter, a "fix" may be simply enabling
> > VT-d in the BIOS.
> > 
> Ah, yes, I think I may have that disabled. I'll check it tonight.

Did you find out if BIOS change fixed this?

thanks,
-chris
