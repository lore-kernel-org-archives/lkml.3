Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbaAJBjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 20:39:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:27036 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930AbaAJBjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 20:39:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,635,1384329600"; 
   d="scan'208";a="456429465"
Message-ID: <52CF4F35.3080805@linux.intel.com>
Date: Fri, 10 Jan 2014 09:39:01 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/vt-d: fix compilation error for IA64 platform
References: <1388989107-4795-20-git-send-email-jiang.liu@linux.intel.com> <1389171427-26223-1-git-send-email-jiang.liu@linux.intel.com> <20140109115501.GI29041@8bytes.org>
In-Reply-To: <20140109115501.GI29041@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Joerg! Sorry for the inconvenience.

On 2014/1/9 19:55, Joerg Roedel wrote:
> On Wed, Jan 08, 2014 at 04:57:07PM +0800, Jiang Liu wrote:
>> Hi Joerg,
>> 	Could you please help to fold this into "[21/22] iommu/vt-d,
>> trivial: clean sparse warnings"?
> 
> Okay, I folded the two patches in, but that is something I'd like to
> avoid because it requires a rebase. So next time please just send a
> follow-up patch to my x86/vt-d branch to fix things up.
> 
> 
> 	Joerg
> 
> 
