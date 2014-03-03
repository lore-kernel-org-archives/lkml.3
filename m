Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbaCCQCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:02:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:36275 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbaCCQCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:02:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,578,1389772800"; 
   d="scan'208";a="465563136"
Date: Mon, 3 Mar 2014 07:58:50 -0800
From: "David E. Box" <david.e.box@linux.intel.com>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 0/2] x86: IOSF: Add loadable module support
Message-ID: <20140303155850.GA2879@linux.intel.com>
References: <1393609674-2999-1-git-send-email-david.e.box@linux.intel.com>
 <1393641652-7222-1-git-send-email-david.e.box@linux.intel.com>
 <531428D9.1060101@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531428D9.1060101@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 03:01:45PM +0800, Li, Aubrey wrote:
> Hi David,
> 
> I'm probably too late to catch this thread. Just one question, what's
> the relationship between
> 	arch/x86/kernel/iosf_mbi.c
> and
> 	drivers/platform/x86/intel_baytrail.c
> 
iosf_mbi.c is the version that went upstream, no longer specific to baytrail.

david box
