Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab3EUGrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:47:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:28312 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab3EUGrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:47:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,712,1363158000"; 
   d="scan'208";a="316989554"
Message-ID: <519B187F.4070504@intel.com>
Date: Tue, 21 May 2013 14:47:27 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH v2] sched: wake-affine throttle
References: <5164DCE7.8080906@linux.vnet.ibm.com> <519AE7F2.706@linux.vnet.ibm.com>
In-Reply-To: <519AE7F2.706@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 11:20 AM, Michael Wang wrote:
> CC: Mike Galbraith <efault@gmx.de>
> CC: Alex Shi <alex.shi@intel.com>

You can change CC to
Reviewed-by: Alex Shi <alex.shi@intel.com>

-- 
Thanks
    Alex
