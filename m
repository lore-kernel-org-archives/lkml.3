Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396Ab3EGSBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 14:01:23 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:39400 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312Ab3EGSBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 14:01:22 -0400
MIME-Version: 1.0
In-Reply-To: <1367947574-2934383-1-git-send-email-arnd@arndb.de>
References: <1367947574-2934383-1-git-send-email-arnd@arndb.de>
Date: Tue, 7 May 2013 11:01:21 -0700
X-Google-Sender-Auth: c9YRGHE-fjJA0HZ7004VN73WTBg
Message-ID: <CA+55aFxJB3OG+-tu2SqAOzn9T7zDb0P9jgbUOMHnXs9m_nXNUA@mail.gmail.com>
Subject: Re: [GIT PULL 0/5] ARM: Third batch of arm-soc changes for 3.10, again
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: ARM SoC <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 10:26 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> Here are the same pull requests as before, with numbers and distinct
> time stamps. I hope I didn't screw up in a different way this time.

Ok, I notice that you seem to have forgotten the "--summary" flag from
your diffstat in your new script.

Not a showstopper, but make sure that the diffstat flags are

  "git diff -M --stat --summary"

(And yes, I prefer "-M", not "-C", because while copy information is
interesting, it tends to hide the fact that the copying added a lot of
lines, so the "-C" flag ends up not giving as good line add/del
information, even if the data that something looks like a copy of
another file is interesting).

              Linus
