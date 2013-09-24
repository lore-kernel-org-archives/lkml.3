Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3IXKiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 06:38:25 -0400
Received: from 8bytes.org ([85.214.48.195]:45188 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab3IXKiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 06:38:24 -0400
Date: Tue, 24 Sep 2013 12:38:17 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: alex.williamson@redhat.com, Varun.Sethi@freescale.com, aik@ozlabs.ru,
        joe@perches.com, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, tony@atomide.com, ohad@wizery.com,
        andreas.herrmann@calxeda.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH 0/7] iommu: Add event tracing feature to iommu
Message-ID: <20130924103816.GA4532@8bytes.org>
References: <cover.1376587770.git.shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1376587770.git.shuah.kh@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Sep 24 12:38:22 2013
X-DSPAM-Confidence: 0.9984
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 52416b9e20861327219891
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 11:59:22AM -0600, Shuah Khan wrote:
> Shuah Khan (7):
>   iommu: Add event tracing feature to iommu
>   iommu: Change iommu driver to call add_device_to_group trace event
>   iommu: Change iommu driver to call remove_device_to_group trace event
>   iommu: Change iommu driver to call attach_device_to_domain trace
>     event
>   iommu: Change iommu driver to call detach_device_to_domain trace
>     event
>   iommu: Change iommu driver to call map trace event
>   iommu: Change iommu driver to call unmap trace event

Applied to tracing branch, thanks Shuah.


