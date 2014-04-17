Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbaDQFoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 01:44:10 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:36680 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbaDQFoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 01:44:08 -0400
Message-ID: <534F6A18.7010900@gmail.com>
Date: Thu, 17 Apr 2014 07:43:52 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jim Lieb <jlieb@panasas.com>, nfs-ganesha-devel@lists.sourceforge.net,
        Jeremy Allison <jra@samba.org>
CC: mtk.manpages@gmail.com, libc-alpha <libc-alpha@sourceware.org>,
        Jeff Layton <jlayton@redhat.com>,
        Michael Kerrisk-manpages <mtk.manpages@googlemail.com>,
        "Carlos O'Donell" <carlos@redhat.com>, samba-technical@lists.samba.org,
        lkml <linux-kernel@vger.kernel.org>, Jeremy Allison <jra@google.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [Nfs-ganesha-devel] should we change the name/macros of file-private
 locks?
References: <20140416145746.66b7441c@tlielax.poochiereds.net> <CAKgNAkgqZDcT0jda8XS+4HrJzXjzwehqciHbkNuAVY3fNkH4zQ@mail.gmail.com> <20140416201633.GQ22791@samba2> <2369283.4ufWfMqZox@jlieb-e6410>
In-Reply-To: <2369283.4ufWfMqZox@jlieb-e6410>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 02:31 AM, Jim Lieb wrote:
> On Wednesday, April 16, 2014 13:16:33 Jeremy Allison wrote:
>> On Wed, Apr 16, 2014 at 10:00:46PM +0200, Michael Kerrisk (man-pages) wrote:
>>> [CC += Jeremy Allison]
>>>
>>> On Wed, Apr 16, 2014 at 8:57 PM, Jeff Layton <jlayton@redhat.com> wrote:
>>>> Sorry to spam so many lists, but I think this needs widespread
>>>> distribution and consensus.
>>>>
>>>> File-private locks have been merged into Linux for v3.15, and *now*
>>>> people are commenting that the name and macro definitions for the new
>>>> file-private locks suck.
>>>>
>>>> ...and I can't even disagree. They do suck.
>>>>
>>>> We're going to have to live with these for a long time, so it's
>>>> important that we be happy with the names before we're stuck with them.
>>>
>>> So, to add my perspective: The existing byte-range locking system has
>>> persisted (despite egregious faults) for well over two decades. One
>>> supposes that Jeff's new improved version might be around
>>> at least as long. With that in mind, and before setting in stone (and
>>> pushing into POSIX) a model of thinking that thousands of programmers
>>> will live with for a long time, it's worth thinking about names.
>>>
>>>> Michael Kerrisk suggested several names but I think the only one that
>>>> doesn't have other issues is "file-associated locks", which can be
>>>> distinguished against "process-associated" locks (aka classic POSIX
>>>> locks).
>>>
>>> The names I have suggested are:
>>>     file-associated locks
>>>
>>> or
>>>
>>>    file-handle locks
>>>
>>> or (using POSIX terminology)
>>>
>>>     file-description locks
>>
>> Thanks for the CC: Michael, but to be honest
>> I don't really care what the name is, I just
>> want the functionality. I can change our build
>> system to cope with detecting it under any name
>> you guys choose :-).
>>
>> Cheers,
>>
>> 	Jeremy.
> 
> I and the rest of the nfs-ganesha community are with Jeremy and samba wrt 
> names.  We just want locks that work, i.e. Useful Locks ;)

Yes, sure. The functionality is coming in any case, thanks to Jeff.
The point is: let's make the API as sane as we can. And that's what
this thread is about, so if you have insights or opinions on good 
naming, that would be helpful.

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
