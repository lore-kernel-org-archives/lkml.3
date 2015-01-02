Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbbABWt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 17:49:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbbABWtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 17:49:55 -0500
Date: Fri, 2 Jan 2015 23:49:52 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
cc: Richard Weinberger <richard@nod.at>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Aaron Tomlin <atomlin@redhat.com>,
        DaeSeok Youn <daeseok.youn@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, vdavydov@parallels.com,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [PATCH] [RFC] Deter exploit bruteforcing
In-Reply-To: <20150102224646.GB29018@amd>
Message-ID: <alpine.LNX.2.00.1501022348070.16297@pobox.suse.cz>
References: <1419457167-15042-1-git-send-email-richard@nod.at> <CAGXu5jKxzyjzoY_khgZu7TbxMhfG3jiXGObiaiUhx6g5-k9c6Q@mail.gmail.com> <20150102051142.GF4873@amd> <54A67A38.3000207@nod.at> <20150102194616.GA27538@amd> <54A7103E.6020500@nod.at> <20150102222936.GA29018@amd>
 <alpine.LRH.2.00.1501022331060.30884@twin.jikos.cz> <20150102224646.GB29018@amd>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jan 2015, Pavel Machek wrote:

> > You also want to protect against binaries that are evil on purpose,
> > right?
> 
> Umm. No. Not by default. We don't want to break crashme or trinity by
> default.

I thought trinity is issuing syscalls directly (would make more sense than 
going through glibc, wouldn't it?) ... haven't checked the source though.

-- 
Jiri Kosina
SUSE Labs
