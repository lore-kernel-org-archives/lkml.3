Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab3HZTCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 15:02:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab3HZTCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 15:02:43 -0400
Date: Mon, 26 Aug 2013 20:56:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] proc: make proc_fd_permission() thread-friendly
Message-ID: <20130826185622.GB30917@redhat.com>
References: <20130825052317.GZ27005@ZenIV.linux.org.uk> <20130825065039.GB9299@1wt.eu> <CA+55aFwFeCRcwn4qo570Y15mKrN3jEdN757PcZhrXs7QYi8MYA@mail.gmail.com> <20130825194844.GA16717@redhat.com> <CA+55aFzbY3zYD1i5x02Z-6K3nHKzJj6227ZBYRLqij9y0eXRqQ@mail.gmail.com> <20130826153301.GA15890@redhat.com> <20130826163704.GA21763@redhat.com> <20130826175441.GA28856@redhat.com> <87ioyspaju.fsf@xmission.com> <20130826184631.GA30917@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826184631.GA30917@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26, Oleg Nesterov wrote:
>
> And I also assume that you agree with this change ;)

At least I hope... Because I think this is another issue.

And because with or without a /proc/thread symlink, I believe that
people don't expect that /proc/self can restrict a sub-thread, and
CLONE_THREAS without CLONE_FILES is exotic.

Oleg.

