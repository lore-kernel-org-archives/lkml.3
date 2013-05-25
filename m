Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab3EYPQu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 11:16:50 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:46893 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab3EYPQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 11:16:48 -0400
Message-ID: <51A0D5DD.1060409@colorfullife.com>
Date: Sat, 25 May 2013 17:16:45 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ipc/sem.c: fix lockup, restore FIFO behavior
References: <1369472095-30195-1-git-send-email-manfred@colorfullife.com> <51A0C166.4000503@redhat.com>
In-Reply-To: <51A0C166.4000503@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

On 05/25/2013 03:49 PM, Rik van Riel wrote:
> On 05/25/2013 04:54 AM, Manfred Spraul wrote:
>>
>> But: Let's wait if this really exists: An application that does rarely
>> complex operations (and that doesn't prefer FIFO semantics).
>
> I do not like that downside at all.
>
> The danger of staying in "too slow to be useful" mode forever
> is really not a risk I want to take.
>

I've modified the patch so that it leaves the mode as soon as possible.
Are you aware of any real-life apps that use multiple semops?

--
     Manfred
