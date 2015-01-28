Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbbA1WDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 17:03:49 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:49674 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbbA1UXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:23:08 -0500
Message-ID: <54C88BB5.3010100@huawei.com>
Date: Wed, 28 Jan 2015 15:11:49 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: <lizf@kernel.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 3.4 177/177] x86/tls: Validate TLS entries to protect
 espfix
References: <1422418050-12581-1-git-send-email-lizf@kernel.org> <1422418236-12852-268-git-send-email-lizf@kernel.org> <20150128065115.GA9007@1wt.eu>
In-Reply-To: <20150128065115.GA9007@1wt.eu>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.54C88BD7.0149,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 39446de5cb1e9a8850151529cf521577
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/28 14:51, Willy Tarreau wrote:
> Hi Li,
> 
> On Wed, Jan 28, 2015 at 12:10:35PM +0800, lizf@kernel.org wrote:
>> From: Andy Lutomirski <luto@amacapital.net>
>>
>> 3.4.106-rc1 review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>>
>> commit 41bdc78544b8a93a9c6814b8bbbfef966272abbe upstream.
>>
>> Installing a 16-bit RW data segment into the GDT defeats espfix.
>> AFAICT this will not affect glibc, Wine, or dosemu at all.
>>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> Acked-by: H. Peter Anvin <hpa@zytor.com>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>> Cc: security@kernel.org <security@kernel.org>
>> Cc: Willy Tarreau <w@1wt.eu>
>> Signed-off-by: Ingo Molnar <mingo@kernel.org>
>> Signed-off-by: Zefan Li <lizefan@huawei.com>
> 
> This patch has introduced a few minor regressions for which Andy has
> provided fixes already pending in latest stable previews, so maybe it
> could make sense to either pick them as well or delay all of them for
> another round. Greg has queued them in his latest preview if you are
> interested (eg: 19/32 and 20/32 for 3.10.67) :
> 
> - e30ab18 ("x86, tls, ldt: Stop checking lm in LDT_empty")
> - 3669ef9 ("x86, tls: Interpret an all-zero struct user_desc as "no segment"")
> 

I think I'll queue them for this release.

Thanks!

