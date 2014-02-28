Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaB1Gy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 01:54:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:30512 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbaB1Gy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 01:54:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,560,1389772800"; 
   d="scan'208";a="483360562"
Message-ID: <531032A0.8090903@linux.intel.com>
Date: Fri, 28 Feb 2014 14:54:24 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Len.Brown@intel.com, Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
References: <53100C8D.1060001@linux.intel.com> <20140228045637.GA28257@srcf.ucam.org> <53101D1D.9010202@linux.intel.com> <20140228055629.GA847@srcf.ucam.org> <531027BE.2010807@linux.intel.com> <20140228061254.GA2226@srcf.ucam.org> <53102AB9.40600@linux.intel.com> <20140228062325.GA3246@srcf.ucam.org> <53102F3C.4020806@linux.intel.com> <20140228064413.GA4900@srcf.ucam.org>
In-Reply-To: <20140228064413.GA4900@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/28 14:44, Matthew Garrett wrote:
> On Fri, Feb 28, 2014 at 02:39:56PM +0800, Li, Aubrey wrote:
> 
>> Just let you know, Windows8.1 calls EFI on these boxes for reboot/shutdown.
> 
> Ok, in that case we should add EFI reboot to the list once Matt's 1:1 
> mapping support has landed. The right place to try it is probably after 
> the second attempt to perform an ACPI reboot. I'm still not enthusiastic 
> about adding cf9 by default.
> 

I'll defer to you if no one on the list supports me to add cf9.

Thanks,
-Aubrey
