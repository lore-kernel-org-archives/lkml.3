Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbaGKRke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 13:40:34 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:38118 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaGKRkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 13:40:33 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140711170411.GJ1870@gmail.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
	<1405029027-6085-8-git-send-email-oded.gabbay@amd.com>
	<20140711170411.GJ1870@gmail.com>
Date: Fri, 11 Jul 2014 19:40:32 +0200
X-Google-Sender-Auth: UosMHuis2ibY1rdQ6xMJg_yJJ4c
Message-ID: <CAKMK7uG4kNe2sGftpiUM0JOtRNVgq5JnrO0Lkb4CDRaThRSVFw@mail.gmail.com>
Subject: Re: [PATCH 09/83] hsa/radeon: Add code base of hsa driver for AMD's GPUs
From: Daniel Vetter <daniel@ffwll.ch>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>, Sandeep Nair <sandeep_n@ti.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Kenneth Heitke <kheitke@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 7:04 PM, Jerome Glisse <j.glisse@gmail.com> wrote:
> Are we to assume that for eternity this will not work on iommu that do support
> PASID/ATS but are not from AMD ? If it was an APU specific function i would
> understand but it seems that the IOMMU API needs to grow. I am pretty sure
> Intel will have an ATS/PASID IOMMU.

Also this isn't just for gpus - I hear noises that it e.g. could also
be used to virtualize a single ethernet NIC to different guest OS
directly. Adding ats/pasid support to the linux iommu interfaces
sounds like the right approach to me.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
