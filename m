Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbaLIEdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 23:33:01 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:41496 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbaLIEdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 23:33:00 -0500
MIME-Version: 1.0
In-Reply-To: <1418097704-29232-1-git-send-email-linux@roeck-us.net>
References: <1418097704-29232-1-git-send-email-linux@roeck-us.net>
Date: Mon, 8 Dec 2014 20:32:59 -0800
X-Google-Sender-Auth: JybYoSSw3lfbrxUTjRWS0qWefYM
Message-ID: <CA+55aFyTuO5Nsj7qg_xKo0JT-YCJEvMk2+QGKH_pRb=BYcba2g@mail.gmail.com>
Subject: Re: [GIT PULL] hwmon updates for 3.19
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 8:01 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>
> Please pull hwmon updates for Linux 3.19 from signed tag:
>
>     git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus-v3.19

Yeah, no, that doesn't exist.

But this does:

>   git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus-3.19

Notice the 'v' (or lack-there-of). It took me a while to notice that
your two tag-names weren't actually the same.

                  Linus
