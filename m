Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235Ab3BFFIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 00:08:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:48262 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab3BFFIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 00:08:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,613,1355126400"; 
   d="scan'208";a="287176752"
Message-ID: <5111E568.9020408@intel.com>
Date: Wed, 06 Feb 2013 13:08:56 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com> <510F1064.1060302@intel.com> <20130204110959.GE24173@gmail.com> <51106DE0.1060103@intel.com>
In-Reply-To: <51106DE0.1060103@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW,

Since numa balance scheduling is also a kind of cpu locality policy, it
is natural compatible with power aware scheduling.

The v2/v3 of this patch had developed on tip/master, testing show above
2 scheduling policy work together well.

-- 
Thanks Alex
