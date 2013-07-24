Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab3GXJ7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 05:59:55 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:41152 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3GXJ7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 05:59:54 -0400
Message-ID: <51EFA559.9050601@linux.vnet.ibm.com>
Date: Wed, 24 Jul 2013 15:28:49 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linuxppc-dev@lists.ozlabs.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] cpuidle/powernv: cpuidle backend driver for powernv
References: <20130723090111.7291.99479.stgit@deepthi.in.ibm.com> <20130723090137.7291.36657.stgit@deepthi.in.ibm.com> <20130723140645.GI31944@concordia>
In-Reply-To: <20130723140645.GI31944@concordia>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072409-3864-0000-0000-0000093BB362
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 07:36 PM, Michael Ellerman wrote:
> On Tue, Jul 23, 2013 at 02:31:41PM +0530, Deepthi Dharwar wrote:
>> This patch implements a back-end cpuidle driver for
>> powernv calling power7_nap and snooze idle states.
>> This can be extended by adding more idle states
>> in the future to the existing framework.
> 
> Other than the state table and a few minor details this looks almost
> identical to the pseries driver. Can we not have a single version in
> sysdev and isolate just the differences?
>

Hi Michael,

Yes, I was actually looking at consolidating and moving all the powerpc
cpuidle driver code to drivers/cpuidle/. sysdev also seems fine. Let me
redo and club the drivers and have a single version of the code in
sysdev for both powerpc and powernv platforms.

Thanks !
Deepthi


> cheers
> 

