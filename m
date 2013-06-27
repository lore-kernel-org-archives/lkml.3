Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab3F0TMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 15:12:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:41322 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab3F0TMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:12:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,954,1363158000"; 
   d="scan'208";a="261059356"
Date: Thu, 27 Jun 2013 22:15:53 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ACPI+PM] Changes for v3.11 merge window, no more new material
 for v3.11 (please)
Message-ID: <20130627191553.GB9294@intel.com>
References: <2857260.qHcRpz1Po6@vostro.rjw.lan>
 <20130627190842.GA9294@intel.com>
 <16355875.t52aFJBBuQ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16355875.t52aFJBBuQ@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 09:15:50PM +0200, Rafael J. Wysocki wrote:
> On Thursday, June 27, 2013 10:08:42 PM Mika Westerberg wrote:
> > On Thu, Jun 27, 2013 at 02:27:01PM +0200, Rafael J. Wysocki wrote:
> > > Hi All,
> > > 
> > > Below is a summary of my current queue for the v3.11 merge window.
> > > 
> > > I will be very reluctant to add anything that is not a fix for a serious
> > > problem to it from now on.  If you have such a fix, please let me know,
> > > however.
> > > 
> > > Other material will be queued up for 3.12, but I'd very much appreciate it
> > > if people refrained from sending me stuff which is not fixes until the
> > > release of 3.11-rc1.
> > 
> > I wonder what happened to the acpi_os_get_timer() patch?
> > 
> > https://patchwork.kernel.org/patch/2605021/
> 
> Well, I'm not sure to be honest.  I'll take it for 3.11.

Thanks!
