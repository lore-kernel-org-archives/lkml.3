Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbaADC55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 21:57:57 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25822 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbaADC54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 21:57:56 -0500
Message-ID: <52C7789E.9090408@oracle.com>
Date: Fri, 03 Jan 2014 21:57:34 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Bob Liu <bob.liu@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, khlebnikov@openvz.org,
        LKML <linux-kernel@vger.kernel.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: mm: kernel BUG at include/linux/swapops.h:131!
References: <52B1C143.8080301@oracle.com> <52B871B2.7040409@oracle.com> <52C508FA.9030009@oracle.com>
In-Reply-To: <52C508FA.9030009@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 01:36 AM, Bob Liu wrote:
> I have no idea why this BUG_ON was triggered.
> And it looks like 'mm: kernel BUG at mm/huge_memory.c:1440!' have the
> same call trace with this one. Perhaps they were introduced by the same
> reason.
> Could you confirm whether those issues exist in v3.13-rc6?

Yes, this is reproducible in 3.13-rc6.


Thanks,
Sasha
