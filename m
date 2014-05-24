Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaEXMZZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 08:25:25 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:37543 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaEXMYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 08:24:51 -0400
Message-ID: <538038EB.20505@gmail.com>
Date: Sat, 24 May 2014 08:15:07 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>,
        Jeff Layton <jlayton@poochiereds.net>
CC: mtk.manpages@gmail.com, libc-alpha@sourceware.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>, Rich Felker <dalias@libc.org>,
        samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        Stefan Metzmacher <metze@samba.org>,
        Christoph Hellwig <hch@infradead.org>,
        Boaz Harrosh <bharrosh@panasas.com>, "Alfred M. Szmidt" <ams@gnu.org>
Subject: Re: [v4, resend] fcntl-linux.h: add new definitions and manual updates
 for open file description locks
References: <1399124004-5535-1-git-send-email-jlayton@poochiereds.net> <20140523155747.GA14101@domone.podge>
In-Reply-To: <20140523155747.GA14101@domone.podge>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 05:57 PM, Ondřej Bílka wrote:
> On Sat, May 03, 2014 at 09:33:24AM -0400, Jeff Layton wrote:
>> Open file description locks have been merged into the Linux kernel for
>> v3.15.  Add the appropriate command-value definitions and an update to
>> the manual that describes their usage.
>>
>> ChangeLog:
>>
>> 2014-04-24  Jeff Layton  <jlayton@poochiereds.net>
>>
>> 	[BZ#16839]
>> 	* manual/llio.texi: add section about open file description locks
>>
>> 	* sysdeps/unix/sysv/linux/bits/fcntl-linux.h:
>> 	  (F_OFD_GETLK, F_OFD_SETLK, F_OFD_SETLKW): New macros.
>>
>  manual/examples/ofdlocks.c entry is missing.
>  
> Otherwise ok for me, Carlos, Michael do you have additional comments?
> .

After commenting quite extensively on two or three previous rounds of 
the patches, I have no further comments. (Jeff integrated/responded 
to all my comments).

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
