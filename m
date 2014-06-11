Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaFKW5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 18:57:24 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63962 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751797AbaFKW5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 18:57:23 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: todd.e.brandt@linux.intel.com
Cc: Steven Rostedt <rostedt@goodmis.org>, rafael.j.wysocki@intel.com,
        linux-pm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM: trace events for device pm callbacks
Date: Thu, 12 Jun 2014 01:14:48 +0200
Message-ID: <11508767.lTNI5hDeGY@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140611204215.GA8988@linux.intel.com>
References: <20140610143122.GA12851@linux.intel.com> <1740847.aJcviUsT1q@vostro.rjw.lan> <20140611204215.GA8988@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 11, 2014 01:42:16 PM Todd E Brandt wrote:
> Is this accepted?

Yes, applied.  Thanks!

> On Tue, Jun 10, 2014 at 11:41:33PM +0200, Rafael J. Wysocki wrote:
> > On Tuesday, June 10, 2014 05:17:16 PM Steven Rostedt wrote:
> > > On Tue, 10 Jun 2014 23:17:46 +0200
> > > "Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:
> > > 
> > > > On Tuesday, June 10, 2014 07:31:22 AM Todd E Brandt wrote:
> > > > > Adds two trace events which supply the same info that initcall_debug 
> > > > > provides, but via ftrace instead of dmesg. The existing initcall_debug
> > > > > calls require the pm_print_times_enabled var to be set (either via
> > > > > sysfs or via the kernel cmd line). The new trace events provide all the
> > > > > same info as the initcall_debug prints but with less overhead, and also
> > > > > with coverage of device prepare and complete device callbacks.
> > > > > 
> > > > > These events replace the device_pm_report_time event (which has been
> > > > > removed). device_pm_callback_start is called first and provides the device
> > > > > and callback info. device_pm_callback_end is called after with the
> > > > > device name and error info. The time and pid are gathered from the trace
> > > > > data headers.
> > > > > 
> > > > > Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
> > > > 
> > > > Steve needs to see this (CCed).
> > > 
> > > The trace events look fine. Is there anything else you wanted me to
> > > look at?
> > 
> > No, that's all, thanks!
> > 
> > Rafael
> > 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
