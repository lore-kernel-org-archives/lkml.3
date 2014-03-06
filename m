Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbaCFDtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 22:49:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:5904 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbaCFDta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 22:49:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,597,1389772800"; 
   d="scan'208";a="493227678"
Message-ID: <5317F044.8080407@linux.intel.com>
Date: Wed, 05 Mar 2014 19:49:24 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, mingo@redhat.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        "alan@linux.intel.com" <alan@linux.intel.com>
Subject: Re: [PATCH] x86: new Intel Atom SoC power management controller driver
References: <5317EC0C.4010807@linux.intel.com>
In-Reply-To: <5317EC0C.4010807@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 07:31 PM, Li, Aubrey wrote:
> The Power Management Controller (PMC) controls many of the power
> management features present in the SoC. This driver provides
> interface to configure the Power Management Controller (PMC).
> 
> This driver exposes PMC device state and sleep state residency
> via debugfs for observation:
> 	/sys/kernel/debugfs/pmc_atom/dev_state
> 	/sys/kernel/debugfs/pmc_atom/sleep_state
> 
> This driver also provides a native power off function via PMC PCI
> IO port.
> 

What is the reason for putting this in debugfs?

	-hpa


