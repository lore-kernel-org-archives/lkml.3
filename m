Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab3JKSYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 14:24:42 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:42220 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab3JKSYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 14:24:41 -0400
MIME-Version: 1.0
In-Reply-To: <525799AC.4090201@synopsys.com>
References: <525799AC.4090201@synopsys.com>
Date: Fri, 11 Oct 2013 11:24:39 -0700
X-Google-Sender-Auth: saSHQLRSJ0vJY6S7D1Eoy9HDFSg
Message-ID: <CA+55aFyKrTi96duyjE5dhQLJBOrVUPEvPkQhwrfa=si+ez9bMQ@mail.gmail.com>
Subject: Re: [GIT PULL] ARC fix for 3.12.-rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        anton Kolesov <Anton.Kolesov@synopsys.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 11:24 PM, Vineet Gupta
<Vineet.Gupta1@synopsys.com> wrote:
> The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:
>
>   Linux 3.12-rc4 (2013-10-06 14:00:20 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/

Nothing there.

I'm *assuming* that you meant to point me at the "for-curr" branch,
which does indeed contain the commit you talk about, but I want these
things to be explicit rather than have to guess from your pull request
and doing "git ls-remote".

Please fix your script.

           Linus
