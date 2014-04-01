Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaDAPkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:40:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:25597 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbaDAPkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:40:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,773,1389772800"; 
   d="scan'208";a="484877472"
Date: Tue, 1 Apr 2014 08:34:53 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Robin Hack <rhack@redhat.com>
Cc: Eunbong Song <eunb.song@samsung.com>, sasha.levin@oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Re: tools/liblockdep: Build failure
Message-ID: <20140401153453.GK32556@tassilo.jf.intel.com>
References: <22212997.138341396332274687.JavaMail.weblogic@epml01>
 <20140401080258.GA10429@bigoook.brq.redhat.com>
 <20140401081144.GB10429@bigoook.brq.redhat.com>
 <20140401102159.GC10429@bigoook.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140401102159.GC10429@bigoook.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 12:21:59PM +0200, Robin Hack wrote:
> From: Robin Hack <rhack@redhat.com>
> Copy asmlinkage macro to lockdep/uinclude/linux/linkage.h.

You can just do 

#define asmlinkage 
#define __visible

for this case.  don't need all the ifdefs or the attribute in the
userspace build.

-Andi
