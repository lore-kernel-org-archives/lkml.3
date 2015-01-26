Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbbAZMQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:16:25 -0500
Received: from 8bytes.org ([81.169.241.247]:46236 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbbAZMQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:16:21 -0500
Date: Mon, 26 Jan 2015 13:16:18 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: alex.williamson@redhat.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu: fix trace_map() to report original iova and
 original size
Message-ID: <20150126121618.GA4653@8bytes.org>
References: <1421375383-8930-1-git-send-email-shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421375383-8930-1-git-send-email-shuahkh@osg.samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 07:29:43PM -0700, Shuah Khan wrote:
> iommu_map() calls trace_map() with iova and size. trace_map()
> should report original iova and original size as opposed to
> iova and size after they get changed during mapping. size is
> always zero at the end of mapping which is useless to report
> and iova as it gets incremented, it is not as useful as the
> original iova. Change iommu_map() to call trace_map() to
> report original iova and original size.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> Reported-by: Alex Williamson <alex.williamson@redhat.com>

Applied, thanks.

