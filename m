Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbaDGSZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:25:39 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:40347 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbaDGSZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:25:38 -0400
MIME-Version: 1.0
In-Reply-To: <5994834.HB1sNmNMvL@wuerfel>
References: <5994834.HB1sNmNMvL@wuerfel>
Date: Mon, 7 Apr 2014 11:25:37 -0700
X-Google-Sender-Auth: IooJacpaV5zxAwjaQT4jIHmi8ro
Message-ID: <CA+55aFzLjTxW1d_8wn=8Do8+ze23RHG=y-cfMMz_SsCRayB1yg@mail.gmail.com>
Subject: Re: [PATCH] sched: remove sleep_on() and friends
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2014 at 8:33 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> We haven't quite made it for 2.5, but maybe we can merge this for 3.15.

Ok, I'm applying this immediately, before any new users pop up in
staging or whatever..

            Linus
