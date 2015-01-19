Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbbASOVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:21:50 -0500
Received: from 8bytes.org ([81.169.241.247]:58251 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbbASOVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:21:48 -0500
Date: Mon, 19 Jan 2015 15:21:47 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: alex.williamson@redhat.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu: fix trace_unmap() to report original iova
Message-ID: <20150119142147.GO6343@8bytes.org>
References: <1421452039-7646-1-git-send-email-shuahkh@osg.samsung.com>
 <20150119140400.GN6343@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150119140400.GN6343@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 03:04:00PM +0100, Joerg Roedel wrote:
> Instead of adding another variable I think it is better to just move the
> trace_unmap call before the unmap loop. It can actually replace the
> pr_debug there.

Okay, forget this. I just noticed that your follow-on patch requires
the trace_unmap call to stay there. I applied both patches to my core
branch.


	Joerg

