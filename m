Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab3LJOxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 09:53:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:25756 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab3LJOxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 09:53:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,865,1378882800"; 
   d="scan'208";a="441744667"
Message-ID: <52A72ADC.6000003@linux.intel.com>
Date: Tue, 10 Dec 2013 06:53:16 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        rafael.j.wysocki@intel.com
Subject: Re: questions of cpuidle
References: <52A5C846.30308@linaro.org> <52A5E135.2020500@linux.vnet.ibm.com> <52A6AFD1.4010002@linaro.org>
In-Reply-To: <52A6AFD1.4010002@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/9/2013 10:08 PM, Alex Shi wrote:
> And for monitor/mwait idle method, seems deep c-state cpu need to keep a
> eye on memory bus. So seems the memory controller in cpu package is
> impossible to get into sleep, right?
not the memory bus
the cache coherency logic ;-)

