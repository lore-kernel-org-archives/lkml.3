Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaAPDHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 22:07:47 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43492 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbaAPDHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 22:07:42 -0500
Message-ID: <52D74CF8.8080202@linaro.org>
Date: Thu, 16 Jan 2014 11:07:36 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        lkp@linux.intel.com
Subject: Re: [sched] 73628fba4: +69% context switches
References: <20140111101956.GA11150@localhost> <52D3804A.8060700@linaro.org> <20140116012301.GA2535@localhost> <52D73D9E.8090402@linaro.org> <20140116021811.GA17073@localhost> <52D747E9.9050602@linaro.org> <20140116030142.GA19524@localhost>
In-Reply-To: <20140116030142.GA19524@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 11:01 AM, Fengguang Wu wrote:
> On Thu, Jan 16, 2014 at 10:46:01AM +0800, Alex Shi wrote:
>>>>>>>>>
>>>>>>>>> What's about the aim7 shell_rtns_1 and shared throughput?
>>>>>>>
>>>>>>> The throughputs remain the same.  We only report changed numbers.
>>>>>
>>>>> So many interrupt increase doesn't cause any performance change, that
>>>>> make more doubt of data correction.
>>>>> Could you like to give the typical vmstat output? Specially the
>>>>> sys/us/wa/id time percentages.
>>
>>> wfg@bee /lkp/result/lkp-ne04/micro/aim7/shell_rtns_1/x86_64-lkp/91dd08bd65052b483f96f75abcc93f2f1b67a62c/1% cat vmstat
>>> 1389799131.230965 procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>>> 1389799131.231067  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>>> 1389799143.207206 1912 26      0 10354424      0 851960    0    0     0     0 8849 31376 28 67  6  0
>>> 1389799144.207531 1515 35      0 10318484      0 852092    0    0     0     0 7670 28332 31 69  0  0
>>> 1389799145.207852 1678 26      0 10303276      0 852196    0    0     0     0 7596 27208 31 69  0  0
>>> 1389799146.208176 1981 43      0 10264672      0 852284    0    0     0     0 7478 27313 31 69  0  0
>>> 1389799147.208500 1977 35      0 10299316      0 852380    0    0     0     0 8505 29552 30 70  0  0
>>
>> That's for the data!

Sorry for typo. I wanted to say 'Thanks for the data' not 'That'. :)
This data is good enough.
> 
> It does not matter in comparison POV. How do you know when aim starts
> the testing phase?
> 
>> Is it the per seconds or per 10 seconds?
> 
> It's per seconds. The first column has the time stamps.

Thanks!
> 
> Thanks,
> Fengguang
> 


-- 
Thanks
    Alex
