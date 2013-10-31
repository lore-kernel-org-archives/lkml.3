Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab3JaXeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 19:34:08 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41840 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3JaXeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 19:34:06 -0400
Message-ID: <5272E8EB.5030900@codeaurora.org>
Date: Thu, 31 Oct 2013 16:34:03 -0700
From: Olav Haugan <ohaugan@codeaurora.org>
Organization: Qualcomm Innovation Center, Inc.
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Luigi Semenzato <semenzato@google.com>
CC: Bob Liu <bob.liu@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: zram/zsmalloc issues in very low memory conditions
References: <526844E6.1080307@codeaurora.org> <52686FF4.5000303@oracle.com> <5269BCCC.6090509@codeaurora.org> <CAA25o9R_jAZyGFU3xYVjsxCCiBwiEC4gRw+JX6WG9X7G-E3LNw@mail.gmail.com>
In-Reply-To: <CAA25o9R_jAZyGFU3xYVjsxCCiBwiEC4gRw+JX6WG9X7G-E3LNw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luigi,

On 10/24/2013 6:12 PM, Luigi Semenzato wrote:
> On Thu, Oct 24, 2013 at 5:35 PM, Olav Haugan <ohaugan@codeaurora.org> wrote:
>> Hi Bob, Luigi,
>>
>> On 10/23/2013 5:55 PM, Bob Liu wrote:
>>>
>>> On 10/24/2013 05:51 AM, Olav Haugan wrote:
>>
>>> By the way, could you take a try with zswap? Which can write pages to
>>> real swap device if compressed pool is full.
>>
>> zswap might not be feasible in all cases if you only have flash as
>> backing storage.
> 
> Zswap can be configured to run without a backing storage.
> 

I was under the impression that zswap requires a backing storage. Can
you elaborate on how to configure zswap to not need a backing storage?


Olav Haugan

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
