Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab3IKQPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:15:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46230 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab3IKQPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:15:16 -0400
Message-ID: <523094CD.3000506@wwwdotorg.org>
Date: Wed, 11 Sep 2013 10:05:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq <cpufreq@vger.kernel.org>
Subject: Re: cpufreq_stats NULL deref on second system suspend
References: <522E1FEF.6080803@wwwdotorg.org> <1775778.MeiRhuYy7o@vostro.rjw.lan> <522F86AD.6010603@wwwdotorg.org> <2521560.SfeNbV74nj@vostro.rjw.lan> <52304439.3030301@linux.vnet.ibm.com>
In-Reply-To: <52304439.3030301@linux.vnet.ibm.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 04:21 AM, Srivatsa S. Bhat wrote:
> On 09/11/2013 04:04 AM, Rafael J. Wysocki wrote:
>> On Tuesday, September 10, 2013 02:53:01 PM Stephen Warren wrote:
>>> On 09/09/2013 05:14 PM, Rafael J. Wysocki wrote:
>>>> On Monday, September 09, 2013 03:29:06 PM Stephen Warren wrote:
>>>>> On 09/09/2013 02:24 PM, Rafael J. Wysocki wrote:
>>>>>> On Monday, September 09, 2013 02:01:32 PM Stephen Warren wrote:
>>>>>>> On 09/09/2013 02:01 PM, Rafael J. Wysocki wrote:
>>>>>>>> On Monday, September 09, 2013 01:22:23 PM Stephen Warren wrote:
>>>>>>>>> Viresh,
>>>>>>>>>
>>>>>>>>> I'm seeing the crash below when suspending my system for the second time.
...
> Stephen, I went through the code and I think I found out what is going wrong.
> Can you please try the following patch?

Unfortunately, I still see the exact same failure/backtrace with this
patch applied.
