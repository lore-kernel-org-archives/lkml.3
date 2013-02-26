Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024Ab3BZBzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 20:55:20 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21054 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab3BZBzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 20:55:17 -0500
Message-ID: <512C15F0.6030907@oracle.com>
Date: Mon, 25 Feb 2013 20:54:56 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Dave Jones <davej@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mm: BUG in mempolicy's sp_insert
References: <512B677D.1040501@oracle.com> <CAHGf_=rur29gFs9R9AYeDwnbVBm3b3cOfAn2xyi=mQ+ZbgzEDA@mail.gmail.com>
In-Reply-To: <CAHGf_=rur29gFs9R9AYeDwnbVBm3b3cOfAn2xyi=mQ+ZbgzEDA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2013 08:52 PM, KOSAKI Motohiro wrote:
> On Mon, Feb 25, 2013 at 8:30 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> Hi all,
>>
>> While fuzzing with trinity inside a KVM tools guest running latest -next kernel,
>> I've stumbled on the following BUG:
>>
>> [13551.830090] ------------[ cut here ]------------
>> [13551.830090] kernel BUG at mm/mempolicy.c:2187!
>> [13551.830090] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> 
> Unfortunately, I didn't reproduce this. I'll try it tonight.

I've actually managed to reproduce it again since then, so it's not a one time
fluke (which is a good sign a I guess).

It did require about an hour of fuzzing just mm with trinity.


Thanks,
Sasha

