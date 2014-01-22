Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbaAVSF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:05:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:54952 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbaAVSF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:05:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,701,1384329600"; 
   d="scan'208";a="462968357"
Date: Wed, 22 Jan 2014 10:09:36 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Fei Yang <fei.yang@intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] x86: don't add new __cpuinit users to Merrifield
 platform code
Message-ID: <20140122180936.GB25171@psi-dev26.jf.intel.com>
References: <1390412125-19439-1-git-send-email-paul.gortmaker@windriver.com>
 <20140122180803.GA25171@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122180803.GA25171@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 10:08:03AM -0800, David Cohen wrote:
> On Wed, Jan 22, 2014 at 12:35:25PM -0500, Paul Gortmaker wrote:
> > Commit bc20aa48bbb3068224a1c91f8332971fdb689fad ("x86, intel-mid:
> > Add Merrifield platform support")  added new instances of __cpuinit
> > usage.  We removed this a couple versions ago; we now want to remove
> > the compat no-op stubs.  Introducing new users is not what we want to
> > see at this point in time, as it will break once the stubs are gone.
> > 
> > This also fixes an out of sync __init vs. __cpuinit -- as the former
> > is real, and the latter is a no-op; hence it would have been a section
> > mismatch.
> > 
> > Cc: David Cohen <david.a.cohen@linux.intel.com>
> > Cc: Fei Yang <fei.yang@intel.com>
> > Cc: H. Peter Anvin <hpa@linux.intel.com>
> > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
> Thanks for the patch.
> 
> Acked-by: David Cohen <david.a.cohen@linux.intel.com>

Grr... wrong acked version :)
I'm getting back this ack.
