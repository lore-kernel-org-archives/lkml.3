Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbaCCNuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 08:50:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:43043 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbaCCNuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 08:50:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,577,1389772800"; 
   d="scan'208";a="465499695"
Message-ID: <1393854614.2193.4.camel@rzhang1-mobl4>
Subject: Re: [RFC PATCH 0/8] ACPI: change the way of enumerating
 PNPACPI/Platform devices
From: Zhang Rui <rui.zhang@intel.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>
Date: Mon, 03 Mar 2014 21:50:14 +0800
In-Reply-To: <1393433267.14900.3.camel@x230>
References: <1393405874-3266-1-git-send-email-rui.zhang@intel.com>
	 <1393433267.14900.3.camel@x230>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-26 at 16:47 +0000, Matthew Garrett wrote:
> On Wed, 2014-02-26 at 17:11 +0800, Zhang Rui wrote:
> 
> > 1. without the patch, the acpi_platform scan handler white list is
> >    continuously growing.
> > 2. with the patch set, the PNPACPI scan handler white list will become
> >    smaller and smaller by
> >    a) remove the ids from the PNPACPI white list, for the devices
> >       that are never enumerated via ACPI
> >    b) remove the ids from the PNPACPI whilte list and convert the drivers to
> >       platform bus drivers, for the devices that are not PNP devices in nature.
> >    which will be done later.
> 
> I agree that this is the right direction to go in. The number of acpipnp
> devices that are also pnpbios or (even worse) isapnp is (a) unlikely to
> increase, and (b) *very* small, and pretty much limited to superio and a
> small number of sound cards on old laptops. We may come up with a better
> solution for them later, but right now shifting away from requiring that
> every new ACPI device driver also bump a whitelist is an improvement.
> 
thanks for your comments, Matthew.

thanks,
rui


