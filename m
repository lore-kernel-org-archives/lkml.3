Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaGaPGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:06:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59099 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaGaPGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:06:39 -0400
Message-ID: <53DA5B5D.7030709@zytor.com>
Date: Thu, 31 Jul 2014 08:06:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Grant Likely <grant.likely@linaro.org>, Andi Kleen <ak@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <len.brown@intel.com>,
        Jiang Liu <jiang.liu@linux.intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [GIT PULL] x86, apic: Cleanups of obsoleted code
References: <alpine.DEB.2.02.1407302346450.17503@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1407302346450.17503@chino.kir.corp.google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 11:53 PM, David Rientjes wrote:
> Hi Ingo, Peter, and Thomas,
> 
> Please pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rientjes/linux.git x86/apic
> 
>   # HEAD: c11645f83e72cbfcf1841a3a821123f3254b9922 x86, apic: Remove enable_apic_mode callback
> 
> or apply individually.  This branch is based on x86/apic.
> 
> Now that I've removed the summit and es7000 subarchitectures, and Peter
> was able to remove NUMAQ, quite a bit of obsoleted code has been left
> behind.
> 
> This cleans up the obsoleted code and generalizes the implementation.

Thank you for doing this.  Running tests on it now.

	-hpa

