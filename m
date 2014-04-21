Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaDUSnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:43:10 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:43942 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaDUSnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:43:07 -0400
Message-ID: <535566B6.6070700@gmail.com>
Date: Mon, 21 Apr 2014 20:43:02 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Jeff Layton <jlayton@redhat.com>,
        Rich Felker <dalias@libc.org>
CC: mtk.manpages@gmail.com, libc-alpha <libc-alpha@sourceware.org>,
        "Carlos O'Donell" <carlos@redhat.com>, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        linux-fsdevel@vger.kernel.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com> <20140421140246.GB26358@brightrain.aerifal.cx> <535529FA.8070709@gmail.com>	<20140421161004.GC26358@brightrain.aerifal.cx> <20140421124508.4f2c9ca7@tlielax.poochiereds.net> <53555CF0.8030405@mit.edu>
In-Reply-To: <53555CF0.8030405@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 08:01 PM, Andy Lutomirski wrote:
> On 04/21/2014 09:45 AM, Jeff Layton wrote:
>> On Mon, 21 Apr 2014 12:10:04 -0400
>> Rich Felker <dalias@libc.org> wrote:
>>> I'm well aware of that. The problem is that the proposed API is using
>>> the two-letter abbreviation FD, which ALWAYS means file descriptor and
>>> NEVER means file description (in existing usage) to mean file
>>> description. That's what's wrong.
>>>
>>
>> Fair enough. Assuming we kept "file-description locks" as a name, what
>> would you propose as new macro names?
> 
> F_OFD_...?  F_OPENFILE_...?
> 
> If you said "file description" to me, I'd assume you made a typo.  If,
> on the other hand, you said "open file" or "open file description" or,
> ugh, "struct file", I think I'd understand.

"Open file description locks" is a mouthful, but, personally, I could
live with it. "struct file" is not a term that belongs in user-space.
"open file" is too ambiguous, IMO.


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
