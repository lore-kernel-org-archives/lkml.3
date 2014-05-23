Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaEWEV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 00:21:58 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38466 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaEWEV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 00:21:57 -0400
Message-ID: <537ECCDB.8080009@oracle.com>
Date: Fri, 23 May 2014 00:21:47 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.15.0-rc6: VM_BUG_ON_PAGE(PageTail(page), page)
References: <20140522135828.GA24879@redhat.com>
In-Reply-To: <20140522135828.GA24879@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 09:58 AM, Dave Jones wrote:
> Not sure if Sasha has already reported this on -next (It's getting hard
> to keep track of all the VM bugs he's been finding), but I hit this overnight
> on .15-rc6.  First time I've seen this one.

Unfortunately I had to disable transhuge/hugetlb in my testing .config since
the open issues in -next get hit pretty often, and were unfixed for a while
now.

Keeping them enabled just made it impossible to test anything else.


Thanks,
Sasha
