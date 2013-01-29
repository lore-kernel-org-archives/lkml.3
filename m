Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab3A2C01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:26:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:41211 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349Ab3A2C0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:26:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,555,1355126400"; 
   d="scan'208";a="283338815"
Message-ID: <5107337E.1050201@intel.com>
Date: Tue, 29 Jan 2013 10:27:10 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Borislav Petkov <bp@alien8.de>, torvalds@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>  <20130124094439.GB13463@pd.tnic> <51014E34.60309@intel.com>  <510493E4.8060602@intel.com> <1359261385.5803.46.camel@marge.simpson.net>  <20130127103508.GB8894@pd.tnic> <51052ACB.3070703@intel.com>  <1359301903.5805.11.camel@marge.simpson.net>  <1359350266.5783.39.camel@marge.simpson.net> <1359388055.5783.164.camel@marge.simpson.net>
In-Reply-To: <1359388055.5783.164.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 11:47 PM, Mike Galbraith wrote:
> 014776  00059528
> 
> Ok box, whatever blows your skirt up.  I'm done.

Many thanks for so much fruitful testing! :D

-- 
Thanks Alex
