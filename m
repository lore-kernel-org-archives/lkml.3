Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab3H0Sek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 14:34:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab3H0Sej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:34:39 -0400
Date: Tue, 27 Aug 2013 20:28:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Willy Tarreau <w@1wt.eu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [PATCH 1/1] proc: make /proc/self point to thread
Message-ID: <20130827182816.GA2992@redhat.com>
References: <20130826153301.GA15890@redhat.com> <20130826163704.GA21763@redhat.com> <20130826175441.GA28856@redhat.com> <CA+55aFzCghYYF1_dcvBY9XZ82TU9b=hhgFqkGoWpaZuKJ7R6_A@mail.gmail.com> <CA+55aFwAw=AZNqmDNip_P6WiY4zGRNWks-kLwN7ZgJ8JJsAx-A@mail.gmail.com> <20130827143938.GA19425@redhat.com> <20130827144004.GB19425@redhat.com> <CA+55aFzoXyA8TU5XXqaNj1EzZ9H-pbTbJ85--zhWzAOLThyjSQ@mail.gmail.com> <20130827174916.GA802@redhat.com> <CA+55aFwwLtxWbNnHO-8Nrpo5q9W=3D-oubUeJ3pFZCxCa4__RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwwLtxWbNnHO-8Nrpo5q9W=3D-oubUeJ3pFZCxCa4__RQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27, Linus Torvalds wrote:
>
> On Tue, Aug 27, 2013 at 10:49 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Although to be honest, I was seduced by "Worth testing". I mean I am
> > just curious, who can suffer from this change? Nevermind, please
> > ignore.
>
> Yeah, if we were to redesign /proc I'd do it differently, but I think
> we should just accept that it works "well enough" and there's just too
> much risk from making changes that aren't strictly required.

Yes, agreed.

To all: just in case, I will be completely offline till Sep 10, vacation.

So, Eric, if you still disagree with s/task_pid/task_tgid/ change please
nack that (minor) patch, we can return to this later.

Oleg.

