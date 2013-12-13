Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab3LMOVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:21:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab3LMOVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:21:34 -0500
Date: Fri, 13 Dec 2013 15:21:30 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
cc: Kees Cook <keescook@chromium.org>, Ryan Mallon <rmallon@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>, vegard.nossum@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
In-Reply-To: <20131213111027.75bcc430@alan.etchedpixels.co.uk>
Message-ID: <alpine.LRH.2.00.1312131519350.7125@twin.jikos.cz>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com> <20131212190659.GG13547@thunk.org> <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com> <52AA4BC8.1080207@gmail.com> <CAGXu5j+mutYTfWWQ0fiKiTkO-Owo6SrikT=xhTrSP+kaDQge8g@mail.gmail.com>
 <20131213111027.75bcc430@alan.etchedpixels.co.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec 2013, One Thousand Gnomes wrote:

> Note however if you trip one of those in any code with the console lock
> held and your log goes to the consoles due to printk level or similar
> you'll probably hang the box.

Also if someone is holding current->alloc_lock.

-- 
Jiri Kosina
SUSE Labs

