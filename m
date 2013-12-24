Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab3LXDBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 22:01:35 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49040 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478Ab3LXDBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 22:01:34 -0500
Message-ID: <52B8F8F6.1080500@oracle.com>
Date: Mon, 23 Dec 2013 22:01:10 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, khlebnikov@openvz.org,
        LKML <linux-kernel@vger.kernel.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Bob Liu <bob.liu@oracle.com>
Subject: Re: mm: kernel BUG at include/linux/swapops.h:131!
References: <52B1C143.8080301@oracle.com> <52B871B2.7040409@oracle.com> <20131224025127.GA2835@lge.com>
In-Reply-To: <20131224025127.GA2835@lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2013 09:51 PM, Joonsoo Kim wrote:
> On Mon, Dec 23, 2013 at 12:24:02PM -0500, Sasha Levin wrote:
>> >Ping?
>> >
>> >I've also Cc'ed the "this page shouldn't be locked at all" team.
> Hello,
>
> I can't find the reason of this problem.
> If it is reproducible, how about bisecting?

While it reproduces under fuzzing it's pretty hard to bisect it with
the amount of issues uncovered by trinity recently.

I can add any debug code to the site of the BUG if that helps.


Thanks,
Sasha
