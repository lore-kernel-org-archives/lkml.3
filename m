Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaADOZv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 09:25:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34376 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaADOZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 09:25:50 -0500
Message-ID: <52C819E2.8090509@oracle.com>
Date: Sat, 04 Jan 2014 09:25:38 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: mm: kernel BUG at mm/huge_memory.c:1440!
References: <52B88F6E.8070909@oracle.com> <20131223200255.GA18521@node.dhcp.inet.fi> <52B8AAFD.5090401@oracle.com>
In-Reply-To: <52B8AAFD.5090401@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2013 04:28 PM, Sasha Levin wrote:
> On 12/23/2013 03:02 PM, Kirill A. Shutemov wrote:
>>> [  265.474585] kernel BUG at mm/huge_memory.c:1440!
>> Could you dump_page() on the bug?
>
> [  469.007946] page:ffffea0005bd8000 count:3 mapcount:0 mapping:ffff8800bcd3d171 index: 0x7fca81000
> [  469.009362] page flags: 0x2afffff80090018(uptodate|dirty|swapcache|swapbacked)

Ping? It still shows up in 3.13-rc6.


Thanks,
Sasha

