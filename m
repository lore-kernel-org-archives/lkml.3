Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab3KYUxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:53:39 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51237 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751665Ab3KYUxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:53:38 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: John Stultz <john.stultz@linaro.org>
Cc: Amit Pundir <amit.pundir@linaro.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH v3] epoll: drop EPOLLWAKEUP if PM_SLEEP is disabled
Date: Mon, 25 Nov 2013 22:06:24 +0100
Message-ID: <2040672.yVPCuBR9mE@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5293A74F.9000808@linaro.org>
References: <1384500391-20513-1-git-send-email-amit.pundir@linaro.org> <3183942.lOJ03BL8GG@vostro.rjw.lan> <5293A74F.9000808@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 25, 2013 11:38:55 AM John Stultz wrote:
> On 11/15/2013 03:53 PM, Rafael J. Wysocki wrote:
> >
> > OK, I'll pick this up over the weekend if Al doesn't do that first.
> 
> Just wanted to follow up on this, since I couldn't find this in your git
> tree or Al's yet.  Forgive me if I missed it, I just wanted to make sure
> it didn't get lost in the shuffle.

It did in fact. :-/

I'm going to queue it up for the next PM pull request (later this week).

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
