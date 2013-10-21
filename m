Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab3JUHBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 03:01:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:4470 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab3JUHBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 03:01:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="310433617"
Date: Mon, 21 Oct 2013 10:06:32 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] gpiolib / ACPI: document the GPIO descriptor
 based interface
Message-ID: <20131021070632.GY3521@intel.com>
References: <1381392071-21407-1-git-send-email-mika.westerberg@linux.intel.com>
 <1381392071-21407-6-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdaAgsoO=w6=LDqE4-JZaOY7Ooofa_L2tRL2Hnt6SNh70g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaAgsoO=w6=LDqE4-JZaOY7Ooofa_L2tRL2Hnt6SNh70g@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 19, 2013 at 11:35:39PM +0200, Linus Walleij wrote:
> On Thu, Oct 10, 2013 at 10:01 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > In addition to the existing ACPI specific GPIO interface, document the new
> > descriptor based GPIO interface in Documentation/acpi/enumeration.txt, so
> > it is clear that this new interface is preferred over the ACPI specific
> > version.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> 
> I've applied the last 4 of these patches now as well, on top of
> Alexandre's gpiod interface. If you can, please test the result
> on my "devel" branch and let's see if the autobuilder likes it too...

Just tested using your devel branch and works fine with GPIOs from ACPI
namespace.

Thanks!
