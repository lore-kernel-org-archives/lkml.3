Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbaFJVR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:17:29 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:7938 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753665AbaFJVR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:17:27 -0400
Date: Tue, 10 Jun 2014 17:17:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: todd.e.brandt@linux.intel.com, rafael.j.wysocki@intel.com,
        linux-pm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM: trace events for device pm callbacks
Message-ID: <20140610171716.694c8414@gandalf.local.home>
In-Reply-To: <3737184.526pO4COlv@vostro.rjw.lan>
References: <20140610143122.GA12851@linux.intel.com>
	<3737184.526pO4COlv@vostro.rjw.lan>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014 23:17:46 +0200
"Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:

> On Tuesday, June 10, 2014 07:31:22 AM Todd E Brandt wrote:
> > Adds two trace events which supply the same info that initcall_debug 
> > provides, but via ftrace instead of dmesg. The existing initcall_debug
> > calls require the pm_print_times_enabled var to be set (either via
> > sysfs or via the kernel cmd line). The new trace events provide all the
> > same info as the initcall_debug prints but with less overhead, and also
> > with coverage of device prepare and complete device callbacks.
> > 
> > These events replace the device_pm_report_time event (which has been
> > removed). device_pm_callback_start is called first and provides the device
> > and callback info. device_pm_callback_end is called after with the
> > device name and error info. The time and pid are gathered from the trace
> > data headers.
> > 
> > Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
> 
> Steve needs to see this (CCed).

The trace events look fine. Is there anything else you wanted me to
look at?

-- Steve

