Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaDRNiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:38:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:42828 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbaDRNiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:38:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,884,1389772800"; 
   d="scan'208";a="495365591"
Date: Fri, 18 Apr 2014 06:38:12 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, mmarek@suse.cz, hpa@zytor.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] Kbuild, lto: Avoid reported warning with strtoul
Message-ID: <20140418133812.GA11200@tassilo.jf.intel.com>
References: <1397795756-23283-1-git-send-email-andi@firstfloor.org>
 <20140418044904.GM18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418044904.GM18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 05:49:04AM +0100, Al Viro wrote: 
> On Fri, Apr 18, 2014 at 06:35:56AM +0200, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Apparently someone's C library declares strtoul with warn_unused_result.
> > Cast to void to avoid the warning. Error handling is not useful here.
> 
> Umm...  Since we don't give a fsck for the value, isn't that simply

Yes your code is equivalent to mine.

-Andi
