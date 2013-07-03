Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423Ab3GCSpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:45:06 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56678 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932919Ab3GCSpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:45:01 -0400
Date: Wed, 3 Jul 2013 19:44:34 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>, john.ronciak@intel.com,
        miles.j.penner@intel.com, bruce.w.allan@intel.com,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 0/8] Thunderbolt workarounds
Message-ID: <20130703184434.GA29587@srcf.ucam.org>
References: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
 <20130703182900.GA29079@srcf.ucam.org>
 <20130703183311.GA17340@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130703183311.GA17340@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 11:33:11AM -0700, Greg Kroah-Hartman wrote:
> On Wed, Jul 03, 2013 at 07:29:00PM +0100, Matthew Garrett wrote:
> > Are there any plans to provide native support for the Thunderbolt 
> > controller, rather than relying on system management mode?
> 
> For what specific hardware platform?  For the ones that this patchset
> controls, the OS doesn't have access to the Thunderbolt controller as
> far as I can tell, it all happens through the ACPI and PCI hotplug
> interface.

Given that there exist platforms without the SMM implementation, there's 
presumably either a controller or chipset register that controls whether 
SMIs are generated in response to Thunderbolt events.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
