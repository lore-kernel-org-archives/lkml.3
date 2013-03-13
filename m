Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab3CMNxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 09:53:12 -0400
Received: from mail.openrapids.net ([64.15.138.104]:46565 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755585Ab3CMNxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 09:53:08 -0400
Date: Wed, 13 Mar 2013 09:53:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Security Officers <security@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix: compat_rw_copy_check_uvector() misuse in aio,
	readv, writev, and security keys
Message-ID: <20130313135304.GC15843@Krystal>
References: <20130225152036.GA3405@Krystal> <20130311204601.GA22369@kroah.com> <20130311205345.GA9410@Krystal> <CA+55aFxjw0hhDTaCBW-Gy0EW2WjkfmWPC-QS_iQpZ98-kvuJwA@mail.gmail.com> <CA+55aFy3gTpxzghYL6-Z4wYpubokFdQCYYZQ5tsJAr042uwgHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy3gTpxzghYL6-Z4wYpubokFdQCYYZQ5tsJAr042uwgHw@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Tue, Mar 12, 2013 at 11:04 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > That said, the patch definitely looks like the right thing to do. I'll apply it.
> 
> Hmm. I applied it, and then pretty much immediately realized what was
> problematic about it. What about the fs/bio.c one?  This all felt like
> it was still a work-in-progress, and I'm not sure if you had more
> comments or patches coming along?
> 
> Anyway, this particular patch got applied. Does that obviate the need
> for the fs/bio.c one? I didn't follow all the call-chains...

The fs/bio.c issue is unrelated to this patch, so that separate issue
still stands. I did not get any feedback on that private RFC though.

Should I repost it CCing lkml ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
