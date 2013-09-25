Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3IYSCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:02:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab3IYSCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:02:40 -0400
Date: Wed, 25 Sep 2013 19:56:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Hurley <peter@hurleysoftware.com>
Cc: codonell <codonell@redhat.com>, Eduard Benes <ebenes@redhat.com>,
        Karel Srot <ksrot@redhat.com>, Matt Newsome <mnewsome@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: v3.10 breaks T.tcflush (Was: tty: disassociate_ctty() sends
	the extra SIGCONT)
Message-ID: <20130925175612.GA26389@redhat.com>
References: <20130915155006.GA11913@redhat.com> <20130925162125.GA18984@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925162125.GA18984@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25, Oleg Nesterov wrote:
>
> See lsb-test-core/lts_vsx-pcts/tset/POSIX.os/devclass/tcflush/tcflush.c
> attached below. test4() fails with
>
> 	SIGTTOU not received
> 	tcflush(TCIOFLUSH) action was performed
> 	when TOSTOP was set

Just in case... I do not really know if it was broken by 3.10 or earlier.

And of course, I do not know who is actually wrong, kernel or lsb.

Oleg.

