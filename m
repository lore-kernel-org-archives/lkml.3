Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbaAVWOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 17:14:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:15112 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991AbaAVWN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 17:13:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,702,1384329600"; 
   d="scan'208";a="443117984"
Date: Wed, 22 Jan 2014 14:19:04 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, fengguang.wu@intel.com,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>
Subject: Re: [PATCH v2] x86: don't introduce more __cpuinit users in
 intel_mid_weak_decls.h
Message-ID: <20140122221904.GC6519@psi-dev26.jf.intel.com>
References: <52dff2dd.pH9hExjpyBbWvw0a%fengguang.wu@intel.com>
 <1390412055-19341-1-git-send-email-paul.gortmaker@windriver.com>
 <20140122215032.GA6519@psi-dev26.jf.intel.com>
 <52E0404E.4010403@linux.intel.com>
 <52E041E7.4010908@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E041E7.4010908@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 05:10:47PM -0500, Paul Gortmaker wrote:
> On 14-01-22 05:03 PM, H. Peter Anvin wrote:
> > On 01/22/2014 01:50 PM, David Cohen wrote:
> >>>  
> >>> -void * __cpuinit get_penwell_ops()
> >>> +void *get_penwell_ops()
> >>>  {
> >>>  	return &penwell_ops;
> >>>  }
> >>>  
> >>> -void * __cpuinit get_cloverview_ops()
> >>> +void *get_cloverview_ops()
> >>>  {
> >>>  	return &penwell_ops;
> >>>  }
> >>
> > 
> > Can someone also find and fix the missing (void)s?
> 
> Sure, I can do that, if nobody else wants to.

I'm sending it. I'm taking care fixing this intel-mid errors right now.

Br, David

> 
> P.
> --
> 
> > 
> > 	-hpa
> > 
> > 
