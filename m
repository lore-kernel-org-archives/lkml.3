Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab3IYJLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 05:11:20 -0400
Received: from 8bytes.org ([85.214.48.195]:47102 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab3IYJLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 05:11:19 -0400
Date: Wed, 25 Sep 2013 11:11:12 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: alex.williamson@redhat.com, Varun.Sethi@freescale.com, udknight@gmail.com,
        aik@ozlabs.ru, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: Re: [PATCH v4 0/2] iommu: Add iommu_error class event to iommu trace
Message-ID: <20130925091104.GA2850@8bytes.org>
References: <cover.1380056222.git.shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1380056222.git.shuah.kh@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Sep 25 11:11:17 2013
X-DSPAM-Confidence: 0.9985
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5242a8b520861339175435
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 03:21:18PM -0600, Shuah Khan wrote:
> Shuah Khan (2):
>   iommu: Add iommu_error class event to iommu trace
>   iommu: Change iommu driver to call io_page_fault trace event

Applied to the tracing branch, thanks Shuah.


