Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab3HNQSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:18:07 -0400
Received: from 8bytes.org ([85.214.48.195]:50986 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932706Ab3HNQSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:18:03 -0400
Date: Wed, 14 Aug 2013 18:17:58 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: alex.williamson@redhat.com, Varun.Sethi@freescale.com, aik@ozlabs.ru,
        joe@perches.com, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, tony@atomide.com, ohad@wizery.com,
        andreas.herrmann@calxeda.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH v2] iommu: Add event tracing feature to iommu
Message-ID: <20130814161758.GQ28811@8bytes.org>
References: <1375196229-2784-1-git-send-email-shuah.kh@samsung.com>
 <20130814141758.GN28811@8bytes.org>
 <520BAAF0.8000509@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520BAAF0.8000509@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Aug 14 18:18:01 2013
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 520badb920862314715082
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 10:06:08AM -0600, Shuah Khan wrote:
> Is this what you have in mind or does my original patch set minus
> the amd_event and drivers/iommu/amd_iommu.c change?
> 
> Patch 1:
> drivers/iommu/Makefile
> drivers/iommu/iommu-traces.c
> include/trace/events/iommu.h
> 
> One patch for each of the following events?
> 
> iommu:add_device_to_group
> iommu:remove_device_from_group
> iommu:attach_device_to_domain
> iommu:detach_device_from_domain
> iommu:unmap
> iommu:map

Right, please do a seperate patch for each event.

> I see what you are saying. Adding event to report_iommu_fault()
> would cover all IOMMUs. I would like to work on adding an event
> unless you already have it in works.

I don't, so feel free to add one too.


	Joerg


