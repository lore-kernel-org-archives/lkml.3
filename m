Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab3CVDkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 23:40:20 -0400
Received: from shelob.surriel.com ([74.92.59.67]:39163 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab3CVDkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 23:40:19 -0400
Message-ID: <514BD299.2030908@surriel.com>
Date: Thu, 21 Mar 2013 23:40:09 -0400
From: Rik van Riel <riel@surriel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>, hhuang@redhat.com,
        "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ipc,sem: sysv semaphore scalability
References: <1363809337-29718-1-git-send-email-riel@surriel.com> <1363914773.31240.58.camel@buesod1.americas.hpqcorp.net> <CA+55aFz_J6UStcP0Xgnb1j4gRb=X4ogq44xDam3ySxWSrdHT4Q@mail.gmail.com>
In-Reply-To: <CA+55aFz_J6UStcP0Xgnb1j4gRb=X4ogq44xDam3ySxWSrdHT4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 09:23 PM, Linus Torvalds wrote:
> On Thu, Mar 21, 2013 at 6:12 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
>>
>> ipc lock contention:
>> 100 users:  8,74%  (vanilla)    3.17% (v3 patchset)
>> 400 users:  21,86% (vanilla)    5.23% (v3 patchset)
>> 800 users   84,35% (vanilla)    7.39% (v3 patchset)
>
> Ok, I'd call that pretty much "solved". Sure, it's still visible, but
> for being a benchmark that apparently does little else than pound on
> those sysv semaphores, I think we can consider it pretty much fine.
> I'm going to assume that anybody who actually then does any real work
> (ie a database) is never going to see even close to this bad
> contention.
>
> Good job, Rik. I'm assuming we'll be merging this during the 3.10
> merge window, and hopefully the merge conflicts will be sorted out
> too. Rik, Peter, can you look at each others patches and see if you
> can get that sorted out for Andrew?

Will do.

I will rebase this series on top of what is in linux-next.

-- 
All rights reversed.
