Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbaGWPvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:51:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:50609 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757989AbaGWPva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:51:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,718,1400050800"; 
   d="scan'208";a="460473583"
Message-ID: <53CFDA00.4080301@linux.intel.com>
Date: Wed, 23 Jul 2014 08:51:28 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        Adam Williamson <awilliam@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Resend PATCHv3 0/3] x86: new Intel atom SOC power management
 controller driver
References: <53B0FEA9.6060707@linux.intel.com>
In-Reply-To: <53B0FEA9.6060707@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2014 11:07 PM, Li, Aubrey wrote:
> From: Aubrey Li <aubrey.li@linux.intel.com>
> 
> The Power Management Controller (PMC) controls many of the power
> management features present in the SoC. This driver provides the power
> off functionality and s0ix residency control, also provides the SOC
> device state and platform sleep state observation via debugfs.
> 
> v3:
> - split the driver into tree pieces: the power off functionality, the
> s0ix residency control, and the debugfs exports.
> 
> v2:
> - allow pmc_atom and lpc_ich to work at the same time.
> 
> Aubrey Li (3):
>   X86 platform: New Intel Atom SOC power management controller driver
>   x86/pmc_atom: disable a few S0ix wake up events for S0ix residency
>   x86/pmc_atom: expose PMC device state and platform sleep state
> 

Looking at this now.  In the future, please make sure that the patches
are sent as followup messages to the 0/* cover page so they thread
correctly.

	-hpa


