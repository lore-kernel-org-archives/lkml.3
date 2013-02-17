Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3BQUy0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 15:54:26 -0500
Received: from [198.137.202.10] ([198.137.202.10]:54815 "EHLO mail.zytor.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753038Ab3BQUyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 15:54:25 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20130217174824.GA649@onny>
References: <20130217174824.GA649@onny>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Bisected] 3.7-rc1 can't resume
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 17 Feb 2013 12:52:30 -0800
To: Jonas Heinrich <onny@project-insanity.org>, rjw@sisk.pl,
        len.brown@intel.com, pavel@ucw.cz, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Message-ID: <1209aeb9-7d97-4444-9038-31d8fc588270@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

T43 is quite old... which might have exposed unique bugs.  How reliable is the failure?  Even one misidentified commit results in git bisect giving garbage.

Jonas Heinrich <onny@project-insanity.org> wrote:

>Hello,
>since kernel version 3.7-rc1 I can't resume my notebook (Thinkpad T43)
>from suspend2ram anymore.
>
>I started a kernel bisection (see bisection_log in attachement). Also
>see kernel conifg @ attachement.
>
>The culprit commit seems to be: 
>- x86, smap: Do not abuse the [f][x]rstor_checking() functions for user
>space
>commit e139e95590dfebab81841bf7a3ac46500f51a47c
>
>Unfortunately, just reverting the commit did not resolved the issue.
>Maybe I did something wrong, I'm not so familiar with this kind of
>kernel bisection.
>
>Best regards,
>Jonas
>
>ps. I'm not yet subscribed to the mailing list so I hope you'll recieve
>this message.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
