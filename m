Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaEGV1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:27:50 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14879 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbaEGV1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:27:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 07 May 2014 14:22:03 -0700
Date: Wed, 7 May 2014 14:27:46 -0700
From: Christopher Freeman <cfreeman@nvidia.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 0/3] Tegra DMA residue improvements
Message-ID: <20140507212746.GA20137@nvidia.com>
References: <1399411343-12222-1-git-send-email-cfreeman@nvidia.com>
 <5369D4FF.1070004@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5369D4FF.1070004@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 11:38:55PM -0700, Lars-Peter Clausen wrote:
> On 05/06/2014 11:22 PM, Christopher Freeman wrote:
> > A collection of patches to improve Tegra's DMA residual reporting
> >
> 
> It would be nice if you could, while you are at it, also implement the 
> device_salve_caps callback. This will allow clients to automatically pick up 
> things like the supported granularity and other things.
Next patch set will include that.  Thanks.

> 
> - Lars
