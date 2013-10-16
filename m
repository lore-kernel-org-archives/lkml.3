Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290Ab3JPIjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:39:11 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:38148 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab3JPIjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:39:08 -0400
Message-ID: <525E50A6.1070206@colorfullife.com>
Date: Wed, 16 Oct 2013 10:39:02 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Davidlohr Bueso <davidlohr@hp.com>
CC: Libin <huawei.libin@huawei.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, guohanjun@huawei.com,
        xiexiuqi@huawei.com
Subject: Re: [PATCH] ipc/sem.c: fix small codingstyle
References: <1381825183-49576-1-git-send-email-huawei.libin@huawei.com> <1381855484.2354.0.camel@buesod1.americas.hpqcorp.net> <1381862186.22110.33.camel@joe-AO722>
In-Reply-To: <1381862186.22110.33.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On 10/15/2013 08:36 PM, Joe Perches wrote:
> On Tue, 2013-10-15 at 09:44 -0700, Davidlohr Bueso wrote:
>> On Tue, 2013-10-15 at 16:19 +0800, Libin wrote:
>>> From: Li Bin <huawei.libin@huawei.com>
>>>
>>> small codingstyle fix: '*' should be adjacent to the data name.
>> There are *tons* of these, go crazy.
>>
> Here are the whitespace changes proposed by
> $ scripts/checkpatch -f --fix --types=pointer_location,spacing,space_before_tab ipc/*.[ch]
/me hides, probably most of them are mine.

Davidlohr: Do you have anything outstanding for ipc/*.c?
I have nothing.

My proposal would be that the checkpatch -f patch should be added for 
3.14, i.e. let's give the code one more cycle to calm down.
Grek just sent me 47 patches for the backport to 3.10-stable, I don't 
want any whitespace noise right now.

--
     Manfred
