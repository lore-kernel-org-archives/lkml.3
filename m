Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab3LJP2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:28:13 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:39300 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab3LJP2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:28:09 -0500
Message-ID: <52A73301.3030905@linaro.org>
Date: Tue, 10 Dec 2013 23:28:01 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        rafael.j.wysocki@intel.com
Subject: Re: questions of cpuidle
References: <52A5C846.30308@linaro.org> <52A5E135.2020500@linux.vnet.ibm.com> <52A6AFD1.4010002@linaro.org> <52A72ADC.6000003@linux.intel.com>
In-Reply-To: <52A72ADC.6000003@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 10:53 PM, Arjan van de Ven wrote:
> On 12/9/2013 10:08 PM, Alex Shi wrote:
>> And for monitor/mwait idle method, seems deep c-state cpu need to keep a
>> eye on memory bus. So seems the memory controller in cpu package is
>> impossible to get into sleep, right?
> not the memory bus
> the cache coherency logic ;-)
> 

Thanks a lot, Arjan!

But in Intel c7 state, l3 cache also flushed. Are there some other unit
monitor this?

-- 
Thanks
    Alex
