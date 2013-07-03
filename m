Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab3GCT5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:57:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:21843 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127Ab3GCT5X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:57:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,990,1363158000"; 
   d="scan'208";a="360121839"
From: "Ronciak, John" <john.ronciak@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Penner, Miles J" <miles.j.penner@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH v2 0/8] Thunderbolt workarounds
Thread-Topic: [PATCH v2 0/8] Thunderbolt workarounds
Thread-Index: AQHOeBtA1zw+fxVX+U+4yVMqNweJnJlTvKyAgAADLwD//57hoA==
Date: Wed, 3 Jul 2013 19:57:21 +0000
Message-ID: <D38E8E86660E514AB505863C19C9287C73E5F07D@ORSMSX102.amr.corp.intel.com>
References: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
 <20130703182900.GA29079@srcf.ucam.org> <20130703183311.GA17340@kroah.com>
 <20130703184434.GA29587@srcf.ucam.org>
In-Reply-To: <20130703184434.GA29587@srcf.ucam.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are you talking about Apple platforms specifically?

Cheers,
John


> -----Original Message-----
> From: Matthew Garrett [mailto:mjg59@srcf.ucam.org]
> Sent: Wednesday, July 03, 2013 11:45 AM
> To: Greg Kroah-Hartman
> Cc: Mika Westerberg; Bjorn Helgaas; Wysocki, Rafael J; Jesse Barnes;
> Yinghai Lu; Ronciak, John; Penner, Miles J; Allan, Bruce W; Heikki
> Krogerus; Kirill A. Shutemov; linux-kernel@vger.kernel.org; linux-
> acpi@vger.kernel.org; linux-pci@vger.kernel.org; x86@kernel.org
> Subject: Re: [PATCH v2 0/8] Thunderbolt workarounds
> 
> On Wed, Jul 03, 2013 at 11:33:11AM -0700, Greg Kroah-Hartman wrote:
> > On Wed, Jul 03, 2013 at 07:29:00PM +0100, Matthew Garrett wrote:
> > > Are there any plans to provide native support for the Thunderbolt
> > > controller, rather than relying on system management mode?
> >
> > For what specific hardware platform?  For the ones that this patchset
> > controls, the OS doesn't have access to the Thunderbolt controller as
> > far as I can tell, it all happens through the ACPI and PCI hotplug
> > interface.
> 
> Given that there exist platforms without the SMM implementation,
> there's presumably either a controller or chipset register that
> controls whether SMIs are generated in response to Thunderbolt events.
> 
> --
> Matthew Garrett | mjg59@srcf.ucam.org
