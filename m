Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbaBVBKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 20:10:47 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26908 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaBVBKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 20:10:46 -0500
Message-ID: <5307F90C.9060602@oracle.com>
Date: Fri, 21 Feb 2014 20:10:36 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm:  kernel BUG at mm/huge_memory.c:1371!
References: <5307D74C.5070002@oracle.com> <20140221235145.GA18046@node.dhcp.inet.fi>
In-Reply-To: <20140221235145.GA18046@node.dhcp.inet.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 06:51 PM, Kirill A. Shutemov wrote:
> On Fri, Feb 21, 2014 at 05:46:36PM -0500, Sasha Levin wrote:
>> >Hi all,
>> >
>> >While fuzzing with trinity inside a KVM tools guest running latest -next
>> >kernel I've stumbled on the following (now with pretty line numbers!) spew:
>> >
>> >[  746.125099] kernel BUG at mm/huge_memory.c:1371!
> It "VM_BUG_ON_PAGE(!PageHead(page), page);", correct?
> I don't see dump_page() output.

Right. However, I'm not seeing the dump_page() output in the log.

I see that dump_page() has been modified not long ago, I'm looking into it.


Thanks,
Sasha

