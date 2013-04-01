Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab3DAGUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:20:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:4582 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab3DAGUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:20:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,385,1363158000"; 
   d="scan'208";a="310363070"
Message-ID: <5159271B.9050009@intel.com>
Date: Mon, 01 Apr 2013 14:20:11 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, "Wu, Fengguang" <fengguang.wu@intel.com>
Subject: Re: [patch v6 0/21] sched: power aware scheduling
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, the patch set passed fengguang's 0day kbuild testing.

Thanks fengguang!
Alex
