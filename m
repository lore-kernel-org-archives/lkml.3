Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035AbaGYIeC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:34:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:57585 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760008AbaGYIdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:33:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,729,1400050800"; 
   d="scan'208";a="575283430"
Message-ID: <53D215D3.50608@intel.com>
Date: Fri, 25 Jul 2014 16:31:15 +0800
From: Jike Song <jike.song@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: xen-devel@lists.xen.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
CC: "White, Michael L" <michael.l.white@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>, "Li, Susie" <susie.li@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        "Haron, Sandra" <sandra.haron@intel.com>
Subject: [Intel-gfx] [Announcement] Updates to XenGT - a Mediated Graphics
 Passthrough Solution from Intel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

We're pleased to announce an update to Intel Graphics Virtualization Technology (Intel GVT-g, formerly known as XenGT). Intel GVT-g is a complete vGPU solution with mediated pass-through, supported today on 4th generation Intel Core(TM) processors with Intel Graphics processors. A virtual GPU instance is maintained for each VM, with part of performance critical resources directly assigned. The capability of running native graphics driver inside a VM, without hypervisor intervention in performance critical paths, achieves a good balance among performance, feature, and sharing capability. Though we only support Xen on Intel Processor Graphics so far, the core logic can be easily ported to other hypervisors.

The news of this update:

	- Project code name is "XenGT", now official name is Intel Graphics Virtualization Technology (Intel GVT-g)
	- Currently Intel GVT-g supports Intel Processor Graphics built into 4th generation Intel Core processors - Haswell platform
	- Moving forward, XenGT will change to quarterly release cadence. Next update will be around early October, 2014.

This update consists of:

	- Stability fixes, e.g. stable DP support
	- Display enhancements, e.g. virtual monitor support. Users can define a virtual monitor type with customized EDID for virtual machines, not necessarily the same as physical monitors.
	- Improved support for GPU recovery
	- Experimental Windows HVM support. To download the experimental version, see setup guide for details
	- Experimental Hardware Media Acceleration for decoding.


Please refer to the new setup guide, which provides step-to-step details about building/configuring/running Intel GVT-g:

	https://github.com/01org/XenGT-Preview-kernel/blob/master/XenGT_Setup_Guide.pdf


The new source codes are available at the updated github repos:

	Linux: https://github.com/01org/XenGT-Preview-kernel.git
	Xen: https://github.com/01org/XenGT-Preview-xen.git
	Qemu: https://github.com/01org/XenGT-Preview-qemu.git


More information about Intel GVT-g background, architecture, etc can be found at:

	https://www.usenix.org/conference/atc14/technical-sessions/presentation/tian
	http://events.linuxfoundation.org/sites/events/files/slides/XenGT-Xen%20Summit-v7_0.pdf
	https://01.org/xen/blogs/srclarkx/2013/graphics-virtualization-xengt

The previous update can be found here:

	http://lists.xen.org/archives/html/xen-devel/2014-02/msg01848.html

Appreciate your comments!




--
Thanks,
Jike
