Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaDXGUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 02:20:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:64462 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbaDXGUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 02:20:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,917,1389772800"; 
   d="scan'208";a="526179540"
Date: Thu, 24 Apr 2014 09:27:19 +0300
From: "Westerberg, Mika" <mika.westerberg@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Timur Tabi <timur@codeaurora.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
Message-ID: <20140424062719.GZ30677@intel.com>
References: <CAOZdJXU2hN+9TE=XN55TZF_W-0hxHZmK5330i6hwrhOERKFetw@mail.gmail.com>
 <534B93BA.6020406@linux.intel.com>
 <534BFAAF.3070805@codeaurora.org>
 <534D0370.50108@linux.intel.com>
 <535005BA.1040405@codeaurora.org>
 <5357A80B.8030701@linux.intel.com>
 <5357ACF1.9070206@codeaurora.org>
 <20140423135915.GY30677@intel.com>
 <5357D8CC.3080501@codeaurora.org>
 <CACRpkdbk8okbzaZgD=BqeMSOvbEvYNViqamd9i=NAaAWW=T9sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbk8okbzaZgD=BqeMSOvbEvYNViqamd9i=NAaAWW=T9sQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 12:20:12AM +0200, Linus Walleij wrote:
> On Wed, Apr 23, 2014 at 5:14 PM, Timur Tabi <timur@codeaurora.org> wrote:
> 
> > How are the pin muxes normally configured in ACPI?
> 
> VERY good question.

Typically this is done by the boot firmware (BIOS in this case). So the OS
doesn't need to deal with that.

AFAICT ACPI doesn't know anything about pin muxing.
