Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508Ab3GZS3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 14:29:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759451Ab3GZS3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 14:29:50 -0400
Message-ID: <51F2C014.90102@redhat.com>
Date: Fri, 26 Jul 2013 14:29:40 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Jeremy Eder <jeder@redhat.com>, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, youquan.song@intel.com,
        paulmck@linux.vnet.ibm.com, daniel.lezcano@linaro.org,
        len.brown@intel.com
Subject: Re: RFC:  revert request for cpuidle patches e11538d1 and 69a37bea
References: <20130726173306.GB17985@jeder.rdu.redhat.com> <51F2BC31.7000407@redhat.com> <51F2BF8C.7010308@linux.intel.com>
In-Reply-To: <51F2BF8C.7010308@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 02:27 PM, Arjan van de Ven wrote:
> On 7/26/2013 11:13 AM, Rik van Riel wrote:
>
>>
>> Could you try running the tests with just the repeat mode
>> stuff from commit 69a37bea excluded, but leaving the common
>> infrastructure and commit e11538?
>>
>
> personally I think we should go the other way around.
> revert the set entirely first, and now, and get our performance back
> to what it should be
>
> and then see what we can add back without causing the regressions.
> this may take longer, or be done in steps, and that's ok.
>
> the end point may well be the same... but we can then evaluate in the right
> direction.

Works for me. I have no objection to reverting both patches,
if the people planning to fix the code prefer that :)

-- 
All rights reversed
