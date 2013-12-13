Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab3LMKcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 05:32:20 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:41341 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab3LMKcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 05:32:17 -0500
Message-ID: <52AAE214.7020109@ahsoftware.de>
Date: Fri, 13 Dec 2013 11:31:48 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>,
        "Theodore Ts'o" <tytso@mit.edu>, vegard.nossum@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com> <20131212190659.GG13547@thunk.org> <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com> <20131213002523.GA20706@redhat.com> <20131213014220.GB11068@kroah.com>
In-Reply-To: <20131213014220.GB11068@kroah.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.12.2013 02:42, schrieb Greg Kroah-Hartman:
> On Thu, Dec 12, 2013 at 07:25:23PM -0500, Dave Jones wrote:
>> On Thu, Dec 12, 2013 at 01:13:41PM -0800, Kees Cook wrote:
>>
>>   > - who will keep adding these triggers going forward?
>>
>> also..
>>
>> - Who will test the existing triggers are doing the right thing when related code changes.
>
> And:
>    - how do you determine an "expoit attempt" from "userspace program
>      doing something stupid" / "corrupted filesytem mounted"?
>

And what makes a bug marked as exploit more serious than the all the 
other bugs? I assume there exists many, many more serious (fixed or not) 
bugs than just those which found there way into the CVE database. And I 
think most bugs are getting fixed without such a number and often even 
those for which CVEs do exist, the CVE is unknown to the dev(s).

So people might be think they are safe if they call some tool which 
tests for existing CVEs which are marked as such inside the kernel, 
which just isn't the reality.

And, as already mentioned, those CVE marks might block refactoring, as 
devs might become careful to remove such a CVE marker when code changed.

I've never seen a comment inside the kernel sources which does point to 
a CVE, so I assume there already does exists some agreement about not 
doing so.

Regards,

Alexander Holler

