Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaGaRfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:35:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:33865 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbaGaRfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:35:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,773,1400050800"; 
   d="scan'208";a="578337691"
Date: Thu, 31 Jul 2014 10:35:39 -0700
From: Andi Kleen <ak@linux.intel.com>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <len.brown@intel.com>,
        Jiang Liu <jiang.liu@linux.intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [GIT PULL] x86, apic: Cleanups of obsoleted code
Message-ID: <20140731173539.GB5803@tassilo.jf.intel.com>
References: <alpine.DEB.2.02.1407302346450.17503@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407302346450.17503@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 11:53:21PM -0700, David Rientjes wrote:
> Hi Ingo, Peter, and Thomas,
> 
> Please pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rientjes/linux.git x86/apic
> 
>   # HEAD: c11645f83e72cbfcf1841a3a821123f3254b9922 x86, apic: Remove enable_apic_mode callback
> 
> or apply individually.  This branch is based on x86/apic.

Thanks for working on this. Looks good to me from a quick read.

BTW I wonder if finding such dead code could be automated in some way.

-Andi
