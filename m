Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaCBAPO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 19:15:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:57323 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320AbaCBAPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 19:15:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,569,1389772800"; 
   d="scan'208";a="492256400"
Message-ID: <5312780C.6070000@linux.intel.com>
Date: Sun, 02 Mar 2014 08:15:08 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
References: <20140228062325.GA3246@srcf.ucam.org> <53102F3C.4020806@linux.intel.com> <20140228064413.GA4900@srcf.ucam.org> <531032A0.8090903@linux.intel.com> <5310CBB7.4030407@linux.intel.com> <53110977.8080907@linux.intel.com> <53121496.8060603@linux.intel.com> <20140301172256.GA29417@srcf.ucam.org> <53121961.2080209@linux.intel.com> <20140301181951.GA984@srcf.ucam.org> <20140301190117.GA2147@srcf.ucam.org>
In-Reply-To: <20140301190117.GA2147@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/2 3:01, Matthew Garrett wrote:
> In fact, this is already merged 
> (d2f7cbe7b26a74dbbbf8f325b2a6fd01bc34032c), so adding EFI by default 
> should be fine. It'd be nice to instrument Windows on OVMF/qemu in order 
> to verify the ordering used in different situations.
> 
So EFI is finalized. Thanks, -Aubrey


