Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab3GKAqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:46:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:65312 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab3GKAqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:46:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1040,1363158000"; 
   d="scan'208";a="368145391"
Message-ID: <51DE0073.3020403@intel.com>
Date: Thu, 11 Jul 2013 08:46:43 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [PATCH] perf: Update event buffer tail when overwriting old events
References: <1370498286-12801-1-git-send-email-zheng.z.yan@intel.com> <20130708121557.GA17211@twins.programming.kicks-ass.net> <51DD4787.7080504@intel.com> <20130710114408.GS25631@dyad.programming.kicks-ass.net>
In-Reply-To: <20130710114408.GS25631@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 07:44 PM, Peter Zijlstra wrote:
> On Wed, Jul 10, 2013 at 07:37:43PM +0800, Yan, Zheng wrote:
>> On 07/08/2013 08:15 PM, Peter Zijlstra wrote:
>>> On Thu, Jun 06, 2013 at 01:58:06PM +0800, Yan, Zheng wrote:
>>>> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
>>>>         before   overwrite mode      after   overwrite mode
>>>> AVG      1000        999             1046        1044
>>>> STDEV    19.4        19.5            17.1        17.9
>>>
>>> OK, so I was sure I replied to this email; but apparently I didn't :/
>>>
>>> So its still adding about 5% overhead to the regular case; this is sad.
>>>
>>> What does something like the below do?
>>>
>>
>> I re-test the patch on a different 32 core sandybridge-ep machine. the result is quite good.
>>
>>        origin   origin overwrite       modified    modified overwrite
>> AVG    1000      1044                   960        1006
>> STDEV  39.0      26.0                   28.1       14.4
> 
> Nice! -- you did fix the snafu for the overwrite more before testing right?
> 

yes, of course.

Regards
Yan, Zheng
