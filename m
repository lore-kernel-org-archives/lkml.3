Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3EUGwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:52:32 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:33324 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3EUGwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:52:31 -0400
Message-ID: <519B19A5.1010401@linux.vnet.ibm.com>
Date: Tue, 21 May 2013 14:52:21 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH v2] sched: wake-affine throttle
References: <5164DCE7.8080906@linux.vnet.ibm.com> <519AE7F2.706@linux.vnet.ibm.com> <519B187F.4070504@intel.com>
In-Reply-To: <519B187F.4070504@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052106-7014-0000-0000-0000030D2739
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 02:47 PM, Alex Shi wrote:
> On 05/21/2013 11:20 AM, Michael Wang wrote:
>> CC: Mike Galbraith <efault@gmx.de>
>> CC: Alex Shi <alex.shi@intel.com>
> 
> You can change CC to
> Reviewed-by: Alex Shi <alex.shi@intel.com>

Got it, thanks for your review :)

Regards,
Michael Wang

> 

