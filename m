Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaL0MXN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 07:23:13 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35622 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaL0MXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 07:23:10 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sat, 27 Dec 2014 13:23:08 +0100
Message-ID: <CA+icZUU7FMXDJdaQcNNWjb4j37_fDySqENsXhLQCmDp9-cvyew@mail.gmail.com>
Subject: Re: [PATCH] fix handling of wait_for_completion_timeout result
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Not sure which persons and MLs you CCed - I am reading LKML offline ]

Hi,

your patch needs some refreshing...

First your Subject... add a subject-prefix like...

$ git format-patch --subject-prefix="next-20141226"

[ The subject-prefix won't be seen if you push out the commit, but is
good for people to see very quickly against WTF-tree you did your
fixing. ]

Your label...

Check the log in [1] to path/to/file2change, this will tell it to you...

$ git log --oneline drivers/i2c/busses/i2c-imx.c

So your label should be better...

i2c: imx: fix handling of wait_for_completion_timeout result

Seems to be a quick hack :-), some typos in your commit-message...

"wati_for_completion_timeout does not return negative values so
"result" handlin here should be simplified to cover the actually
possible cases only."

*wait*_for_completion_timeout
handlin*g*

Hope this encourages you to do a v2.
Have more fun!

- Sedat -


[1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/drivers/i2c/busses/i2c-imx.c
