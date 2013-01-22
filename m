Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab3AVOIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 09:08:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:33431 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab3AVOID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 09:08:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,514,1355126400"; 
   d="scan'208";a="280548005"
Date: Tue, 22 Jan 2013 22:07:55 +0800
From: Feng Tang <feng.tang@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] x86: Add cpu capability flag
 X86_FEATURE_TSC_S3_NOTSTOP
Message-ID: <20130122140755.GB26140@feng-snb>
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
 <1358750325-21217-2-git-send-email-feng.tang@intel.com>
 <20130121072729.GB11915@gchen.bj.intel.com>
 <20130121075900.GA509@feng-snb>
 <50FD65A8.2030600@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FD65A8.2030600@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 09:58:32AM -0600, H. Peter Anvin wrote:
> On 01/21/2013 01:59 AM, Feng Tang wrote:
> >>>  
> >> We have an existed "TSC always running in C3+" feature and name it as
> >> X86_FEATURE_NONSTOP_TSC, so how about naming it with the same style,
> >> like X86_FEATURE_NONSTOP_TSC_S3?
> > 
> > Yeah, actually I used a name X86_FEATURE_xxx_TSC, then I did a grep,
> > and found there is no unified name convention for TSC, so I chose such
> > a name.
> > 
> 
> I think NONSTOP_TSC_S3 is quite a bit more consistent than S3_NOTSTOP...

Got it, will use that in new version.

Thanks
Feng
