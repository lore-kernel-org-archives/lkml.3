Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab3DSRU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 13:20:56 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:57878 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab3DSRUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 13:20:54 -0400
MIME-Version: 1.0
In-Reply-To: <SNT138-W13141195F26C221B6DE805D7C80@phx.gbl>
References: <SNT138-W13141195F26C221B6DE805D7C80@phx.gbl>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 19 Apr 2013 11:20:33 -0600
Message-ID: <CAErSpo4ENvyxHhg8H=Qs3DcsyDn5MOi4mv669YGWGZvMTkXtWw@mail.gmail.com>
Subject: Re: Kernel bug: opensuse 12.3, lenovo 3000 n100 laptop
To: Scott Simpson <simpson1000@live.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bryan Gartner <bgartner@suse.com>, Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Bryan, Zhang]

On Fri, Apr 19, 2013 at 8:51 AM, Scott Simpson <simpson1000@live.com> wrote:
> Stack trace is here: http://www.flickr.com/photos/94373754@N06/8662259093/                                        --

Hi Scott,

This is an openSUSE bug, so you'll probably get more help there.  I
added a CC: for that, and you can look here as well:
http://en.opensuse.org/openSUSE:Submitting_bug_reports

Is this easy to reproduce?  Do you know whether the same thing happens
with an upstream kernel, e.g., v3.8 or v3.9-rc7?  If it turns out that
this bug still exists in the upstream kernel, Zhang will probably be
interested in it.

Transcribed from the screen shot:

    kernel BUG at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.10/linux-3.7/kernel/sched/core.c:1465!
    Pid: 3742, comm: kworker/0:0 Not tainted 3.7.10-1.1-desktop #1
LENOVO 0768DCU/CAPELL VALLEY(NAPA) CRB
    Call Trace:
      schedule_timeout
      wait_for_common
      stop_one_cpu
      set_cpus_allowed_ptr
      acpi_processor_set_throttling
      thermal_zone_device_update
      process_one_work
      worker_thread
      kthread
      ret_from_kernel_thread
      kthread_create_on_node
    Kernel panic -- not syncing: Watchdog detected hard LOCKUP on cpu 1

Bjorn
