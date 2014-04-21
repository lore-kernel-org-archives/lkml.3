Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaDUUK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 16:10:56 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:46866 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaDUUKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 16:10:51 -0400
Message-ID: <53557B39.8080208@gmail.com>
Date: Mon, 21 Apr 2014 22:10:33 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Rich Felker <dalias@libc.org>, Jeff Layton <jlayton@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>
CC: mtk.manpages@gmail.com
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com> <20140421140246.GB26358@brightrain.aerifal.cx> <535529FA.8070709@gmail.com> <20140421161004.GC26358@brightrain.aerifal.cx> <5355644C.7000801@gmail.com> <20140421184841.GA5105@thunk.org> <20140421185144.GF26358@brightrain.aerifal.cx> <20140421190410.GC5105@thunk.org> <20140421190659.GA10884@infradead.org>
In-Reply-To: <20140421190659.GA10884@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 09:06 PM, Christoph Hellwig wrote:
> On Mon, Apr 21, 2014 at 03:04:10PM -0400, Theodore Ts'o wrote:
>> I think what you mean is that there is no need that we expose the name
>> "struct file".  My point is that "struct file" is actually a much
>> _better_ name than "file description".  Heck, "open file object" would
>> be better name than "file description".
> 
> Open file description is what all current standards use.  I'm pretty
> sure really old ones just used open file, 

("open file description" was already in SUSv1 (1994))

> but struct file has never
> been used in an API description.  

Exactly.

> Introducing it now entirely out of
> context is not helpful at all.

In principle, I agree, though it might be helpful for some
people to mention this term in a side-note in, say, open(2).

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
