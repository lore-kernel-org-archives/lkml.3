Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbaDUSTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:19:13 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:60542 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbaDUSSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:18:54 -0400
Message-ID: <5355610A.6090606@gmail.com>
Date: Mon, 21 Apr 2014 20:18:50 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>, Rich Felker <dalias@libc.org>
CC: mtk.manpages@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com>	<20140421140246.GB26358@brightrain.aerifal.cx>	<535529FA.8070709@gmail.com>	<20140421161004.GC26358@brightrain.aerifal.cx> <20140421124508.4f2c9ca7@tlielax.poochiereds.net>
In-Reply-To: <20140421124508.4f2c9ca7@tlielax.poochiereds.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,
On 04/21/2014 06:45 PM, Jeff Layton wrote:
> On Mon, 21 Apr 2014 12:10:04 -0400
> Rich Felker <dalias@libc.org> wrote:
> 
>> On Mon, Apr 21, 2014 at 04:23:54PM +0200, Michael Kerrisk (man-pages) wrote:
>>> On 04/21/2014 04:02 PM, Rich Felker wrote:
>>>> On Mon, Apr 21, 2014 at 09:45:35AM -0400, Jeff Layton wrote:
[...]
>>>    initial preference, and I also suggested "file-description locks"
>>>    and noted the drawbacks of that term. I think it's insufficient
>>>    to say "stick with the existing poor name"--if you have
>>>    something better, then please propose it. (Note by the way
>>>    that for nearly a decade now, the open(2) man page has followed
>>>    POSIX in using the term "open file description. Full disclosure:
>>>    of course, I'm responsible for that change in the man page.)
>>
>> I'm well aware of that. The problem is that the proposed API is using
>> the two-letter abbreviation FD, which ALWAYS means file descriptor and
>> NEVER means file description (in existing usage) to mean file
>> description. That's what's wrong.
>>
> 
> Fair enough. Assuming we kept "file-description locks" as a name, what
> would you propose as new macro names?

I assume you meant, "assume we kept the term 'file-private locks'..."
In that case, at least make the constants something like

F_FP_SETLK
F_FP_SETLKW
F_FP_GETLK

so that they are not confused with the traditional constants.

Cheer,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
