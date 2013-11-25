Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab3KYTjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:39:00 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34512 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab3KYTi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:38:58 -0500
Message-ID: <5293A74F.9000808@linaro.org>
Date: Mon, 25 Nov 2013 11:38:55 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Amit Pundir <amit.pundir@linaro.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH v3] epoll: drop EPOLLWAKEUP if PM_SLEEP is disabled
References: <1384500391-20513-1-git-send-email-amit.pundir@linaro.org> <2338693.sZIlYGM98f@vostro.rjw.lan> <5286A1A4.2020905@linaro.org> <3183942.lOJ03BL8GG@vostro.rjw.lan>
In-Reply-To: <3183942.lOJ03BL8GG@vostro.rjw.lan>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 03:53 PM, Rafael J. Wysocki wrote:
>
> OK, I'll pick this up over the weekend if Al doesn't do that first.

Just wanted to follow up on this, since I couldn't find this in your git
tree or Al's yet.  Forgive me if I missed it, I just wanted to make sure
it didn't get lost in the shuffle.

thanks
-john

