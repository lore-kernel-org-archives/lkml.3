Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbaDXLbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:31:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:35882 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756123AbaDXLbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:31:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,918,1389772800"; 
   d="scan'208";a="518778872"
Date: Thu, 24 Apr 2014 14:38:22 +0300
From: "Westerberg, Mika" <mika.westerberg@intel.com>
To: Timur Tabi <timur@codeaurora.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
Message-ID: <20140424113822.GF30677@intel.com>
References: <534BFAAF.3070805@codeaurora.org>
 <534D0370.50108@linux.intel.com>
 <535005BA.1040405@codeaurora.org>
 <5357A80B.8030701@linux.intel.com>
 <5357ACF1.9070206@codeaurora.org>
 <20140423135915.GY30677@intel.com>
 <5357D8CC.3080501@codeaurora.org>
 <CACRpkdbk8okbzaZgD=BqeMSOvbEvYNViqamd9i=NAaAWW=T9sQ@mail.gmail.com>
 <20140424062719.GZ30677@intel.com>
 <5358F362.6080006@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5358F362.6080006@codeaurora.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 06:20:02AM -0500, Timur Tabi wrote:
> Westerberg, Mika wrote:
> >Typically this is done by the boot firmware (BIOS in this case). So the OS
> >doesn't need to deal with that.
> >
> >AFAICT ACPI doesn't know anything about pin muxing.
> 
> In that case, would it be correct to say that a Linux pinctrl driver
> for an ACPI-only platform should not define pinmux function groups,
> because they'll never be used?

No because you can have a GPIO controller on ACPI machine that allows you
to do some sort of pin muxing. What I'm saying is that ACPI itself doesn't
have such knowledge and hence we don't support such things in
gpiolib-acpi.c.
