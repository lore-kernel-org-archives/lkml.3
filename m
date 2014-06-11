Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaFKUm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:42:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:3831 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062AbaFKUmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:42:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,460,1400050800"; 
   d="scan'208";a="555937223"
Date: Wed, 11 Jun 2014 13:42:16 -0700
From: Todd E Brandt <todd.e.brandt@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, rafael.j.wysocki@intel.com,
        linux-pm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM: trace events for device pm callbacks
Message-ID: <20140611204215.GA8988@linux.intel.com>
Reply-To: todd.e.brandt@linux.intel.com
References: <20140610143122.GA12851@linux.intel.com>
 <3737184.526pO4COlv@vostro.rjw.lan>
 <20140610171716.694c8414@gandalf.local.home>
 <1740847.aJcviUsT1q@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1740847.aJcviUsT1q@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this accepted?

On Tue, Jun 10, 2014 at 11:41:33PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, June 10, 2014 05:17:16 PM Steven Rostedt wrote:
> > On Tue, 10 Jun 2014 23:17:46 +0200
> > "Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:
> > 
> > > On Tuesday, June 10, 2014 07:31:22 AM Todd E Brandt wrote:
> > > > Adds two trace events which supply the same info that initcall_debug 
> > > > provides, but via ftrace instead of dmesg. The existing initcall_debug
> > > > calls require the pm_print_times_enabled var to be set (either via
> > > > sysfs or via the kernel cmd line). The new trace events provide all the
> > > > same info as the initcall_debug prints but with less overhead, and also
> > > > with coverage of device prepare and complete device callbacks.
> > > > 
> > > > These events replace the device_pm_report_time event (which has been
> > > > removed). device_pm_callback_start is called first and provides the device
> > > > and callback info. device_pm_callback_end is called after with the
> > > > device name and error info. The time and pid are gathered from the trace
> > > > data headers.
> > > > 
> > > > Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
> > > 
> > > Steve needs to see this (CCed).
> > 
> > The trace events look fine. Is there anything else you wanted me to
> > look at?
> 
> No, that's all, thanks!
> 
> Rafael
> 
