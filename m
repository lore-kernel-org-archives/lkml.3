Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968Ab3HNOSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:18:05 -0400
Received: from 8bytes.org ([85.214.48.195]:50782 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757871Ab3HNOSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:18:03 -0400
Date: Wed, 14 Aug 2013 16:17:58 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: alex.williamson@redhat.com, Varun.Sethi@freescale.com, aik@ozlabs.ru,
        joe@perches.com, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, tony@atomide.com, ohad@wizery.com,
        andreas.herrmann@calxeda.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH v2] iommu: Add event tracing feature to iommu
Message-ID: <20130814141758.GN28811@8bytes.org>
References: <1375196229-2784-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375196229-2784-1-git-send-email-shuah.kh@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Aug 14 16:18:01 2013
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 520b919920861403058959
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah,

thanks for doing this. I have a few suggestions for improvements.

On Tue, Jul 30, 2013 at 08:57:09AM -0600, Shuah Khan wrote:
> iommu:add_device_to_group
> iommu:remove_device_from_group
> iommu:attach_device_to_domain
> iommu:detach_device_from_domain
> iommu:unmap
> iommu:map

Please send these events as seperate patches.

> iommu:amd_event

This needs some more thought. For now I would prefer an event in the
generic report_iommu_fault() routine to report page-faults from all IOMMUs
that support this.

Thanks,

	Joerg


