Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaDKGtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 02:49:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:28286 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbaDKGtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 02:49:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,840,1389772800"; 
   d="scan'208";a="511336445"
Date: Fri, 11 Apr 2014 09:56:24 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Oops in acpi_gpiochip_add on MacBookPro with Linux
 v3.14-12042-g69cd9eba3886
Message-ID: <20140411065624.GB19349@intel.com>
References: <CA+5PVA5VBns=hkOSViucrpT340uG0=hgrWqf=LYHTBFAe74tBg@mail.gmail.com>
 <CACna6ry+FOYykZpzycEjDA+ncGNLk6eXkwadXy548h9dgU1Bgw@mail.gmail.com>
 <CA+5PVA4ijLmwRKHD4RYE6qSqkN7p8v1GB9w9GAGAJKG45bBTnw@mail.gmail.com>
 <20140410124045.GX19349@intel.com>
 <CACRpkdaBg5KjvksHRB3z2R6KehYcFC=4MEHedfcE6tP4GTh+Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaBg5KjvksHRB3z2R6KehYcFC=4MEHedfcE6tP4GTh+Qw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 08:47:23PM +0200, Linus Walleij wrote:
> On Thu, Apr 10, 2014 at 2:40 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > On Thu, Apr 10, 2014 at 08:22:12AM -0400, Josh Boyer wrote:
> >> On Thu, Apr 10, 2014 at 2:50 AM, Rafał Miłecki <zajec5@gmail.com> wrote:
> >> > 2014-04-09 23:09 GMT+02:00 Josh Boyer <jwboyer@fedoraproject.org>:
> >> >> With Linux v3.14-12042-g69cd9eba3886 I get an oops from the bcma
> >> >> module on the MacBookPro 10,2 I have here.  This works fine with Linux
> >> >> v3.14-7333-g59ecc26004e7.  There have been no changes between those
> >> >> two versions to bcma itself, but the GPIO merge did go in that window.
> >> >>  I can attempt to do a bisect tomorrow, but looking over some of the
> >> >> GPIO commits it seems pretty relevant to the ACPI GPIO changes.  I'm
> >> >> hoping someone here has an idea on what the issue might be and has
> >> >> some possible things for me to test for fixes.
> >> >
> >> > Bug report: https://lkml.org/lkml/2014/3/24/262
> >> > Patch: https://lkml.org/lkml/2014/3/24/293
> >> > Tested by Sabrina: https://lkml.org/lkml/2014/3/24/304
> >> > (all links are for the same thread).
> >> >
> >> > Now you simply have to find above patch in some git tree :) Not sure
> >> > if it's already in Linus's one.
> >>
> >> Ah, wonderful.  I now wish I would have found those in my searching
> >> before doing the bisect.  Oh well.  For what it's worth, my bisect
> >> landed on the same commit.
> >>
> >> The fix isn't in Linus' tree or linux-next.  I'm guessing Mika is
> >> either still on vacation, or hasn't sent out the formal fix yet.
> >
> > No, not on vacation anymore (unfortunately). I did send the formal patch
> > already:
> >
> > https://lkml.org/lkml/2014/3/31/135
> >
> > but it isn't merged to Linus' GPIO tree yet.
> 
> I've queued this for fixes!
> 
> Will send upstream ASAP.

Thanks!
