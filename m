Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab3LADjX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 22:39:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:39377 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab3LADjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 22:39:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,804,1378882800"; 
   d="scan'208";a="417385196"
Date: Sun, 1 Dec 2013 11:39:53 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel panic due to "PCI / ACPI: Use acpi_find_child_device()
 for child devices lookup"
Message-ID: <20131201033953.GK23378@yliu-dev.sh.intel.com>
References: <20131129052552.GC23378@yliu-dev.sh.intel.com>
 <1662528.KAt6bvD9Oc@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1662528.KAt6bvD9Oc@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 04:33:00PM +0100, Rafael J. Wysocki wrote:
> On Friday, November 29, 2013 01:25:52 PM Yuanhan Liu wrote:
> > Greetings,
> > 
> > We got the follow kernel panic dmesg(full dmesg is attached):
> 
> That patch has been updated in linux-next recently, can you please
> check if you are able to reproduce the problem with the new version?

Hi Rafael,

Yeah, lkp-ib03 boots fine with linux-pm/linux-next. Sorry for the noise.

	--yliu
