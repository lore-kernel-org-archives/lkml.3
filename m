Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaH2Tc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:32:26 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45032 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaH2TcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:32:25 -0400
Message-ID: <5400D535.9080002@oracle.com>
Date: Fri, 29 Aug 2014 15:32:05 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        khlebnikov@openvz.org, riel@redhat.com, mgorman@suse.de,
        mhocko@suse.cz, hughd@google.com, vbabka@suse.cz, walken@google.com,
        minchan@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] Convert a few VM_BUG_ON callers to VM_BUG_ON_VMA
References: <1409324059-28692-1-git-send-email-sasha.levin@oracle.com> <1409324059-28692-3-git-send-email-sasha.levin@oracle.com> <20140829191719.GC12774@nhori.bos.redhat.com>
In-Reply-To: <20140829191719.GC12774@nhori.bos.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2014 03:17 PM, Naoya Horiguchi wrote:
>> -	VM_BUG_ON(!PageLocked(page));
>> > +	VM_BUG_ON_PAGE(!PageLocked(page), page);
> This is not the replacement with VM_BUG_ON_VMA(), but it's fine :)

Woops, I was on a spree and got this one as well.

Thanks for the review Naoya!


Thanks,
Sasha
