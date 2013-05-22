Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab3EVW3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:29:45 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37809 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757564Ab3EVW3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:29:44 -0400
X-IronPort-AV: E=Sophos;i="4.87,724,1363158000"; 
   d="scan'208";a="49762189"
Date: Wed, 22 May 2013 15:29:42 -0700
From: David Brown <davidb@codeaurora.org>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: ohad@wizery.com, joerg.roedel@amd.com, LKML <linux-kernel@vger.kernel.org>,
        joro@8bytes.org, Varun.Sethi@freescale.com,
        iommu@lists.linux-foundation.org, mingo@kernel.org, ddutile@redhat.com
Subject: Re: [PATCH] msm: iommu: fix leak and invalid access
Message-ID: <20130522222942.GA5706@codeaurora.org>
References: <51931347.7020600@huawei.com>
 <519C5E8F.7060006@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519C5E8F.7060006@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 01:58:39PM +0800, Libo Chen wrote:

> ping...

This is the first I've seen this patch.  The original appears to have
been sent to Andrew Morton and lkml.  I'll reply with an Ack there.

David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
