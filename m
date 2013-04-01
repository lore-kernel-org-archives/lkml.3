Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab3DANnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:43:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:19657 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757686Ab3DANnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:43:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,387,1363158000"; 
   d="scan'208";a="287612317"
Message-ID: <51598EEC.8030907@intel.com>
Date: Mon, 01 Apr 2013 21:43:08 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v6 12/21] sched: add power aware scheduling in fork/exec/wake
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com> <1364654108-16307-13-git-send-email-alex.shi@intel.com> <51595876.7030502@linux.vnet.ibm.com>
In-Reply-To: <51595876.7030502@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2013 05:50 PM, Preeti U Murthy wrote:
> sched: Fix power aware scheduling in fork/wake/exec
> 
> From: Preeti U Murthy <preeti@linux.vnet.ibm.com>

Good caught! Thanks Preeti!

Acked-by: Alex Shi <alex.shi@intel.com>

-- 
Thanks
    Alex
