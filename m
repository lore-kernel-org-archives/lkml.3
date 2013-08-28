Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3H1QYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 12:24:50 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:41116 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab3H1QYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 12:24:48 -0400
MIME-Version: 1.0
In-Reply-To: <20130828061623.GJ27005@ZenIV.linux.org.uk>
References: <CA+55aFw20W9L8HV+VbTRNeQQM-_+aeUhvT9AAod5LGfb-7hE9g@mail.gmail.com>
	<7d1419dda1da70a8ad915f85b093a58b86bcaf3b.1377630856.git.luto@amacapital.net>
	<CA+55aFwtVH+MoG7Emt5V5wy2eDbYOBHBgOywRHFQ+Vm2XZn-Ag@mail.gmail.com>
	<CALCETrVerk6evSngbf1fiD=k6E557KgKNCBF4qYQSCXYrOx0ag@mail.gmail.com>
	<20130828061623.GJ27005@ZenIV.linux.org.uk>
Date: Wed, 28 Aug 2013 09:24:48 -0700
X-Google-Sender-Auth: 9VLqDGPjfwMs4lf4N54HGvp2jzA
Message-ID: <CA+55aFyt9sjezUQxqUzQ9ZeqVN-HkejTbtV48Edu8AY+66etfA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: Add user_file_or_path_at and use it for truncate
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@amacapital.net>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@kernel.org>,
        "security@kernel.org" <security@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pseudo-related: I just reverted the flink() commit in my tree, so that
at least wrt that whole thing we'll be back to the original behavior,
broken or not. Clearly we're not done with this discussion, and the
patches flying around aren't appropriate for 3.11, so..

               Linus
