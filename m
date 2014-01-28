Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaA1GHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 01:07:20 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:59276 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747AbaA1GHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 01:07:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al0JAMdI51J5LGaB/2dsb2JhbABagwyDObRkhVCBHBd0giUBAQEEOhwjEAgDGAklDwUlAyETiATJdhcWjmkHhDgBA5gmkiCDQSg
Date: Tue, 28 Jan 2014 17:06:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH v5 00/22] Rewrite XIP code and add XIP support to ext4
Message-ID: <20140128060652.GZ13997@dastard>
References: <cover.1389779961.git.matthew.r.wilcox@intel.com>
 <20140123090133.GR13997@dastard>
 <100D68C7BA14664A8938383216E40DE04061DF33@FMSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <100D68C7BA14664A8938383216E40DE04061DF33@FMSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 12:12:43PM +0000, Wilcox, Matthew R wrote:
> Are you hitting the same problems with ext4 fsck that we did?  Version 1.42.8 reports spurious corruption.  From the 1.42.9 changelog:
> 
>   * Fixed a regression introduced in 1.42.8 which would cause e2fsck to
>     erroneously report uninitialized extents past i_size to be invalid.

Don't think so - I'm running 1.42.9 on my test VM.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
