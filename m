Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab3LWV2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:28:42 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36413 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab3LWV2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:28:41 -0500
Message-ID: <52B8AAFD.5090401@oracle.com>
Date: Mon, 23 Dec 2013 16:28:29 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: mm: kernel BUG at mm/huge_memory.c:1440!
References: <52B88F6E.8070909@oracle.com> <20131223200255.GA18521@node.dhcp.inet.fi>
In-Reply-To: <20131223200255.GA18521@node.dhcp.inet.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2013 03:02 PM, Kirill A. Shutemov wrote:
>> [  265.474585] kernel BUG at mm/huge_memory.c:1440!
> Could you dump_page() on the bug?

[  469.007946] page:ffffea0005bd8000 count:3 mapcount:0 mapping:ffff8800bcd3d171 index: 0x7fca81000
[  469.009362] page flags: 0x2afffff80090018(uptodate|dirty|swapcache|swapbacked)


Thanks,
Sasha
