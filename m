Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab3DJFLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 01:11:44 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35597 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab3DJFLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 01:11:43 -0400
Message-ID: <5164F47D.6060006@linux.vnet.ibm.com>
Date: Wed, 10 Apr 2013 13:11:25 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wake-affine throttle
References: <5164DCE7.8080906@linux.vnet.ibm.com> <5164E7A0.80408@intel.com>
In-Reply-To: <5164E7A0.80408@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041005-3568-0000-0000-0000036757E7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 12:16 PM, Alex Shi wrote:
> On 04/10/2013 11:30 AM, Michael Wang wrote:
>> Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> 
> Reviewed-by: Alex Shi <alex.shi@intel.com>

Thanks for your review :)

> 
> BTW, could you try the kbulid, hackbench and aim for this?

Sure, the patch has already been tested with aim7, also the hackbench,
kbench, and ebizzy, no notable changes on my box with the default 1ms
interval.

Regards,
Michael Wang

> 

