Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbaDUSBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:01:35 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:41132 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaDUSBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:01:24 -0400
Message-ID: <53555CF0.8030405@mit.edu>
Date: Mon, 21 Apr 2014 11:01:20 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>, Rich Felker <dalias@libc.org>
CC: libc-alpha <libc-alpha@sourceware.org>,
        "Carlos O'Donell" <carlos@redhat.com>, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        linux-fsdevel@vger.kernel.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com> <20140421140246.GB26358@brightrain.aerifal.cx> <535529FA.8070709@gmail.com>	<20140421161004.GC26358@brightrain.aerifal.cx> <20140421124508.4f2c9ca7@tlielax.poochiereds.net>
In-Reply-To: <20140421124508.4f2c9ca7@tlielax.poochiereds.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 09:45 AM, Jeff Layton wrote:
> On Mon, 21 Apr 2014 12:10:04 -0400
> Rich Felker <dalias@libc.org> wrote:
>> I'm well aware of that. The problem is that the proposed API is using
>> the two-letter abbreviation FD, which ALWAYS means file descriptor and
>> NEVER means file description (in existing usage) to mean file
>> description. That's what's wrong.
>>
> 
> Fair enough. Assuming we kept "file-description locks" as a name, what
> would you propose as new macro names?

F_OFD_...?  F_OPENFILE_...?

If you said "file description" to me, I'd assume you made a typo.  If,
on the other hand, you said "open file" or "open file description" or,
ugh, "struct file", I think I'd understand.

--Andy
