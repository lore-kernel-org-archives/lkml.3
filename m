Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab3IXKtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 06:49:04 -0400
Received: from 8bytes.org ([85.214.48.195]:45221 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab3IXKtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 06:49:02 -0400
Date: Tue, 24 Sep 2013 12:48:57 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: alex.williamson@redhat.com, Varun.Sethi@freescale.com, udknight@gmail.com,
        aik@ozlabs.ru, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: Re: [PATCH 1/2] iommu: Add iommu_fault class event to iommu trace
Message-ID: <20130924104855.GB4532@8bytes.org>
References: <cover.1376672275.git.shuah.kh@samsung.com>
 <7a14c27d8341e53f2aed7b80e08a4480d89eac5e.1376672275.git.shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a14c27d8341e53f2aed7b80e08a4480d89eac5e.1376672275.git.shuah.kh@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Sep 24 12:49:01 2013
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 52416e1d20861661348221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 11:20:16AM -0600, Shuah Khan wrote:
> +DEFINE_EVENT(iommu_fault, report_fault,
> +
> +	TP_PROTO(struct device *dev, unsigned long iova, int flags),
> +
> +	TP_ARGS(dev, iova, flags)
> +);

I am not entirely happy with the naming. It is better to name the class
iommu_error and the page-fault event io_page_fault. This makes it more
clear what kind of fault it is.


	Joerg


