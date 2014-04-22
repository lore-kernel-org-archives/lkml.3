Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbaDVOpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:45:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33725 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbaDVOpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:45:38 -0400
Message-ID: <5356808B.3040303@gmail.com>
Date: Tue, 22 Apr 2014 17:45:31 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org
CC: linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        libc-alpha <libc-alpha@sourceware.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Carlos O'Donell" <carlos@redhat.com>,
        Stefan Metzmacher <metze@samba.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Frank Filz <ffilzlnx@mindspring.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] locks: rename file-private locks to "open file description
 locks"
References: <1398169383-10743-1-git-send-email-jlayton@redhat.com>
In-Reply-To: <1398169383-10743-1-git-send-email-jlayton@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 03:23 PM, Jeff Layton wrote:
<>
> 
> We're going to have to live with these for a long time, so it's
> important that we be happy with the names before we're stuck with them.
> The consensus on the lists so far is that they should be rechristened as
> "open file description locks".
> 

I completely agree with the rename. (Though could you please post
the rest of the rename patches for review)

Just a very small nit. My native language is not English but I would
rather you use "file-descriptor" (with an '-' as well) and not
use "description" in the English name of the lock. This is
because stated like that, "description" might refer to the
locks and not to the file in the sentence. file-descriptor is
more clear I think. (For me it was confusing at first before I realized
what you meant)

Just my $0.017
Thanks

