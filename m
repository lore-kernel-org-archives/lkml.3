Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab3JNTXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:23:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333Ab3JNTXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:23:53 -0400
Date: Mon, 14 Oct 2013 21:17:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Wong <normalperson@yhbt.net>
Subject: Re: epoll oops.
Message-ID: <20131014191712.GA16886@redhat.com>
References: <20131014154627.GA9525@redhat.com> <CA+55aFw64xTR7LXjo5OfUvRwDb9UF8EcfjguAbF0C3VsUXCecg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw64xTR7LXjo5OfUvRwDb9UF8EcfjguAbF0C3VsUXCecg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14, Linus Torvalds wrote:
>
> Oleg, does this trigger any memory for you? Commit 971316f0503a
> ("epoll: ep_unregister_pollwait() can use the freed pwq->whead") just
> makes me go "Hmm, this is *exactly* that that commit is talking
> about.."

Well. I have to admit I forgot everything I learned about this code
when I tried to fix that bug, and there were some subtle changes after
that... But of course I will try to investigate.

Oleg.

