Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbaAILzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:55:10 -0500
Received: from 8bytes.org ([85.214.48.195]:39705 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbaAILzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:55:05 -0500
Date: Thu, 9 Jan 2014 12:55:01 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/vt-d: fix compilation error for IA64 platform
Message-ID: <20140109115501.GI29041@8bytes.org>
References: <1388989107-4795-20-git-send-email-jiang.liu@linux.intel.com>
 <1389171427-26223-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389171427-26223-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jan  9 12:55:02 2014
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 52ce8e1620861949511286
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 04:57:07PM +0800, Jiang Liu wrote:
> Hi Joerg,
> 	Could you please help to fold this into "[21/22] iommu/vt-d,
> trivial: clean sparse warnings"?

Okay, I folded the two patches in, but that is something I'd like to
avoid because it requires a rebase. So next time please just send a
follow-up patch to my x86/vt-d branch to fix things up.


	Joerg


