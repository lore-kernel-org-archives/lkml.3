Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbaAVSGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:06:08 -0500
Received: from mga14.intel.com ([143.182.124.37]:22191 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbaAVSGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:06:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,701,1384329600"; 
   d="scan'208";a="405344852"
Date: Wed, 22 Jan 2014 10:11:14 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, fengguang.wu@intel.com,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH v2] x86: don't introduce more __cpuinit users in
 intel_mid_weak_decls.h
Message-ID: <20140122181114.GC25171@psi-dev26.jf.intel.com>
References: <52dff2dd.pH9hExjpyBbWvw0a%fengguang.wu@intel.com>
 <1390412055-19341-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390412055-19341-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 12:34:15PM -0500, Paul Gortmaker wrote:
> Commit 85611e3febe78955a519f5f9eb47b941525c8c76 ("x86, intel-mid:
> Add Clovertrail platform support") added new instances of __cpuinit
> usage.  We removed this a couple versions ago; we now want to remove
> the compat no-op stubs.  Introducing new users is not what we want to
> see at this point in time, as it will break once the stubs are gone.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Cc: David Cohen <david.a.cohen@linux.intel.com>
> Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> Cc: Fei Yang <fei.yang@intel.com>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: David Cohen <david.a.cohen@linux.intel.com>

