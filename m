Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab3GJDz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 23:55:28 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40411 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab3GJDz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 23:55:26 -0400
Date: Tue, 9 Jul 2013 20:55:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at drivers/iommu/dmar.c:484 warn_invalid_dmar with
 Intel Motherboard
Message-ID: <20130710035523.GB13149@roeck-us.net>
References: <20130709202406.GA11867@roeck-us.net>
 <CAErSpo6Ma1TnBP-UGGhWFN1rj48y+yTS=VmVw_s30_FWgjfdpg@mail.gmail.com>
 <20130709223106.GA16429@roeck-us.net>
 <20130709232252.GB2676@sequoia2.sous-sol.org>
 <20130709234331.GA10833@roeck-us.net>
 <20130710000511.GC2676@sequoia2.sous-sol.org>
 <20130710001828.GA32072@roeck-us.net>
 <1373417595.26127.27.camel@dwoodhou-mobl5.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373417595.26127.27.camel@dwoodhou-mobl5.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 01:53:15AM +0100, David Woodhouse wrote:
> On Tue, 2013-07-09 at 17:18 -0700, Guenter Roeck wrote:
> > 
> > I meant warning as in pr_warn or dev_warn, not WARNING as in traceback.
> > Keep in mind that a casual user doesn't expect to see a traceback and will tend
> > to get alarmed. Several bugs have been filed against this "issue" in various
> > distributions, which is not surprising given the alarmist message.
> > What is the point of that ?
> 
> It is warning you that your hardware is broken. Take it back to the
> place from which you purchased it, and ask for your money back if it
> isn't fixed.
> 
> (Slightly) more seriously, this level of warning *does* get things
> fixed, and when kerneloops was running it made it very easy to track
> this kind of issue and apply pressure where it was needed to improve
> quality.
> 
> Any user who has taken the trouble to file bugs has *also* taken it up
> with their firmware vendor, I hope?
> 
No idea ... but have you ever tried that as a private entity ?

If there is a secret list of people to contact at vendor X to get things
like this one fixed, please let me know ;).

Thanks,
Guenter
