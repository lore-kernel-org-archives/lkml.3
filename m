Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbaDWN5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:57:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:64237 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756271AbaDWNwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:52:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,912,1389772800"; 
   d="scan'208";a="422510752"
Date: Wed, 23 Apr 2014 16:59:16 +0300
From: "Westerberg, Mika" <mika.westerberg@intel.com>
To: Timur Tabi <timur@codeaurora.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
Message-ID: <20140423135915.GY30677@intel.com>
References: <1371555182-12418-1-git-send-email-mathias.nyman@linux.intel.com>
 <1371555182-12418-2-git-send-email-mathias.nyman@linux.intel.com>
 <CAOZdJXU2hN+9TE=XN55TZF_W-0hxHZmK5330i6hwrhOERKFetw@mail.gmail.com>
 <534B93BA.6020406@linux.intel.com>
 <534BFAAF.3070805@codeaurora.org>
 <534D0370.50108@linux.intel.com>
 <535005BA.1040405@codeaurora.org>
 <5357A80B.8030701@linux.intel.com>
 <5357ACF1.9070206@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5357ACF1.9070206@codeaurora.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 07:07:13AM -0500, Timur Tabi wrote:
> Mathias Nyman wrote:
> >
> >Helper functions to translate the ACPI GpioIO and GpioInt resources to
> >linux gpio numbers can be found in gpio/gpiolib-acpi.c together with
> >other ACPI and gpio related helper functions.
> 
> Does this also cover pin control and pin muxing?  Sorry, but I
> sometimes I get confused.  It appears to me that the GpioIo and
> GpioInt functions require pin muxing, but I don't see that support
> in gpiolib-acpi.

It doesn't do any pin control nor muxing and I'm not sure if it is
required. Can you elaborate why you think pin muxing is required with
GpioIo/GpioInt resources?
