Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab3GGVcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 17:32:19 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:60019 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab3GGVcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 17:32:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAFkjPTmzqPTCxyxfwmZX8w7aeO4D9L3wQ2GPypkP=uyK1U6P9g@mail.gmail.com>
References: <CAFkjPTmzqPTCxyxfwmZX8w7aeO4D9L3wQ2GPypkP=uyK1U6P9g@mail.gmail.com>
Date: Sun, 7 Jul 2013 14:32:16 -0700
X-Google-Sender-Auth: Yfv77pYnaepEyKUOPa3TwqdDebQ
Message-ID: <CA+55aFxOed9ARsDStX_hN_dyRvv5Lza65JLN6Vzu=xihTWEnMw@mail.gmail.com>
Subject: Re: [GIT PULL] 9p changes for 3.11 merge window (part 1)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 7, 2013 at 12:39 PM, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> The following changes since commit c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1:
>
>   Linux 3.9 (2013-04-28 17:36:01 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git
> tags/9p-for-3.11-merge-window-part-1

What the F*CK is wrong with people?

This is the second pull request in minutes that I'm going to have to
reject, this time because all the commits were apparently rebased just
minutes before sending me the pull request. So it clearly hasn't
gotten any testing, and hasn't been in next.

Why? No explanation, no nothing.

                Linus
