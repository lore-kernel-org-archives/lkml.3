Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622AbbA2CCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:02:12 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:41601 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbbA2CCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:02:07 -0500
Message-ID: <54C9949C.9000703@roeck-us.net>
Date: Wed, 28 Jan 2015 18:02:04 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm: split up mm_struct to separate header file
References: <1422451064-109023-1-git-send-email-kirill.shutemov@linux.intel.com> <1422451064-109023-3-git-send-email-kirill.shutemov@linux.intel.com> <20150129003028.GA17519@node.dhcp.inet.fi>
In-Reply-To: <20150129003028.GA17519@node.dhcp.inet.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.54C9949E.00E0,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2015 04:30 PM, Kirill A. Shutemov wrote:
> On Wed, Jan 28, 2015 at 03:17:42PM +0200, Kirill A. Shutemov wrote:
>> We want to use __PAGETABLE_PMD_FOLDED in mm_struct to drop nr_pmds if
>> pmd is folded. __PAGETABLE_PMD_FOLDED is defined in <asm/pgtable.h>, but
>> <asm/pgtable.h> itself wants <linux/mm_types.h> for struct page
>> definition.
>>
>> This patch move mm_struct definition into separate header file in order
>> to fix circular header dependencies.
>>
>> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>
> Guenter, below is update for the patch. It doesn't fix all the issues, but
> you should see an improvement. I'll continue with this tomorrow.
>
I'll give it a try.

> BTW, any idea where I can get hexagon cross compiler?
>

http://www.mentor.com/embedded-software/sourcery-tools/sourcery-codebench/editions/lite-edition/

It is 32 bit, so you'll have to install some 32 bit libraries.

Guenter

