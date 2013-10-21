Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab3JULpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 07:45:24 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:59552 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab3JULpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 07:45:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAGbDTvqC0e0wZpEYHL2kg2wGYFfZt9gx7bQQ8cmbySWHqquWqw@mail.gmail.com>
References: <CAGbDTvqC0e0wZpEYHL2kg2wGYFfZt9gx7bQQ8cmbySWHqquWqw@mail.gmail.com>
Date: Mon, 21 Oct 2013 13:45:19 +0200
Message-ID: <CAFLxGvzvg-h_cRFSQ-W1bT-cgFuRwTOBFO1S842TFK-24xKqMg@mail.gmail.com>
Subject: Re: Looking for configuration-dependent bugs in Linux
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Iago Abal <mail@iagoabal.eu>
Cc: LKML <linux-kernel@vger.kernel.org>, Iago Abal <iari@itu.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 12:49 PM, Iago Abal <mail@iagoabal.eu> wrote:
> Dear Linux kernel developer,
>
> We are a group working on analysis of configurable software systems at
> IT University of Copenhagen. For the next four years [1] we will study
> the problem of verification in highly configurable software, and we
> will focus on the Linux kernel as the prime example of configurable
> software. We will therefore appreciate your advice regarding a few
> questions (see below).
>
> We are currently looking for already-fixed configuration-dependent
> bugs in Linux ---the bugfix helps us to understand the underlying
> cause. A good example is [2], which fixes a bug that only shows up in
> PA-RISC architectures when DISCONTIGMEM is enabled. Any bug appearing
> in some configurations but not in others is interesting for us (e.g. a
> bug affecting PowerPC only), even though the more complex the
> interaction between configuration options the more interesting is the
> bug for our purpose.
>
> As a Linux kernel developer, could you:
>
> * remember any configuration-dependent bug?
> * identify any subset of configuration options that tend to interact badly?
> * spot any part of the kernel more prone to configuration-dependent bugs?

Isn't this your job?
Just read the kernel mainlinglist archives. :-)

> Your feedback will allow us to make our search more effective. A good
> understanding of how these bugs occur in Linux will also be important
> for developing subsequent techniques and tools. There is of course a
> potential benefit for the Linux community: we plan to pay you back in
> bug reports :-)
>
> All your feedback is welcomed.
>
> Thank you for your time.
>
> Kind regards,
>
> [1] http://variete.wikit.itu.dk/
> [2] http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=91ea8207168793b365322be3c90a4ee9e8b03ed4
>
> --
> Iago Abal Rivas - http://www.iagoabal.eu
> Ph.D. Fellow at IT University of Copenhagen
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
