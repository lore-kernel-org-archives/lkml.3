Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab3KAAgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 20:36:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49147 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab3KAAgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 20:36:08 -0400
Message-ID: <5272F766.8000804@oracle.com>
Date: Fri, 01 Nov 2013 08:35:50 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Olav Haugan <ohaugan@codeaurora.org>
CC: Luigi Semenzato <semenzato@google.com>, Minchan Kim <minchan@kernel.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: zram/zsmalloc issues in very low memory conditions
References: <526844E6.1080307@codeaurora.org> <52686FF4.5000303@oracle.com> <5269BCCC.6090509@codeaurora.org> <CAA25o9R_jAZyGFU3xYVjsxCCiBwiEC4gRw+JX6WG9X7G-E3LNw@mail.gmail.com> <5272E8EB.5030900@codeaurora.org>
In-Reply-To: <5272E8EB.5030900@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olav,

On 11/01/2013 07:34 AM, Olav Haugan wrote:
> Hi Luigi,
> 
> On 10/24/2013 6:12 PM, Luigi Semenzato wrote:
>> On Thu, Oct 24, 2013 at 5:35 PM, Olav Haugan <ohaugan@codeaurora.org> wrote:
>>> Hi Bob, Luigi,
>>>
>>> On 10/23/2013 5:55 PM, Bob Liu wrote:
>>>>
>>>> On 10/24/2013 05:51 AM, Olav Haugan wrote:
>>>
>>>> By the way, could you take a try with zswap? Which can write pages to
>>>> real swap device if compressed pool is full.
>>>
>>> zswap might not be feasible in all cases if you only have flash as
>>> backing storage.
>>
>> Zswap can be configured to run without a backing storage.
>>
> 
> I was under the impression that zswap requires a backing storage. Can
> you elaborate on how to configure zswap to not need a backing storage?
> 

AFAIK, currently zswap can't be used without a backing storage.
Perhaps you can take a try by creating a swap device backed by a file on
storage.

-- 
Regards,
-Bob
