Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaINCmf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 22:42:35 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:46254 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaINCme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 22:42:34 -0400
Message-ID: <54150090.1050306@gmail.com>
Date: Sat, 13 Sep 2014 19:42:24 -0700
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: mtk.manpages@gmail.com, "Eric W. Biederman" <ebiederm@xmission.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: For review: user_namespace(7) man page
References: <53F5310A.5080503@gmail.com> <CALCETrX2qwvzmeoVcLFLxEK=1Fv+f0Ri0TouzzvbN_rgDjka4A@mail.gmail.com> <540F0810.7030408@gmail.com> <87ppf4n5ib.fsf@x220.int.ebiederm.org> <5411B5D6.9010201@gmail.com> <CALCETrV1EtrzfEhS55ToPD5VTbY9VjmmOA6bv2H9PGGQ-G=WGA@mail.gmail.com>
In-Reply-To: <CALCETrV1EtrzfEhS55ToPD5VTbY9VjmmOA6bv2H9PGGQ-G=WGA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 08:14 AM, Andy Lutomirski wrote:
> On Thu, Sep 11, 2014 at 7:46 AM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> Hi Eric,
>>
>> On 09/09/2014 09:05 AM, Eric W. Biederman wrote:
>>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>>
>>>> Hi Andy, and Eric,
>>>>>>        1. The  writing  process  must  have  the CAP_SETUID (CAP_SETGID)
>>>>>>           capability in the user namespace of the process pid.
>>>>>
>>>>> This checked for the opening process (and I don't actually remember
>>>>> whether it's checked for the writing process).
>>>>
>>>> Eric, can you comment?
>>>
>>> We have to check for the opening processes and that changes was made
>>> after I implemented my interface. Pieces of the code appear to also
>>> examine the writing process and verify everything applies to it as well.
>>>
>>> I goofed when I designed the interface originall and had not realized
>>> what a classic design error it can be to not restrict by the opening
>>> process.
>>
>> So, I still need some help here. Should the sentence above just read:
>>
>>         1. The  *opening*  process  must  have  the CAP_SETUID (CAP_SETGID)
>>            capability in the user namespace of the process pid.
> 
> I think this is sufficient.
> 
>>
>> or must something also be said about the writing process? (If so, i'd
>> appreciate a completely formed sentence or two that I can just drop into
>> the man page..)
> 
> There might be a restriction there, too, but I think it could be
> removed, and I also think that it's unlikely that anyone will
> encounter it.

Okay. Thanks, Andy.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
