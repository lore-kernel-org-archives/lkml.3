Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab3G2Ltg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 07:49:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:41097 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab3G2Ltd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 07:49:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,768,1367996400"; 
   d="scan'208";a="338415838"
Message-ID: <51F656CC.10104@linux.intel.com>
Date: Mon, 29 Jul 2013 04:49:32 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Rik van Riel <riel@redhat.com>, Jeremy Eder <jeder@redhat.com>,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        youquan.song@intel.com, paulmck@linux.vnet.ibm.com,
        len.brown@intel.com, Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: RFC:  revert request for cpuidle patches e11538d1 and 69a37bea
References: <20130726173306.GB17985@jeder.rdu.redhat.com> <51F2BC31.7000407@redhat.com> <51F2BF8C.7010308@linux.intel.com> <51F2C014.90102@redhat.com> <51F37290.5050101@linaro.org>
In-Reply-To: <51F37290.5050101@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Beside that, on ARM the cpus could be coupled and the timer to detect
> the prediction will wake up the entire cluster, making the power saving
> less efficient and impacting the statistics of the other cpu.

an ARM specific governor would be quite appropriate in that case.

