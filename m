Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab3DOLQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 07:16:39 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:48340 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab3DOLQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 07:16:37 -0400
MIME-Version: 1.0
In-Reply-To: <1366012739.21182.4.camel@leyfoon-vm>
References: <1366012739.21182.4.camel@leyfoon-vm>
Date: Mon, 15 Apr 2013 13:16:36 +0200
Message-ID: <CAFLxGvw7Cj_wz_A9B+fBR6jYxi+73Ofh-PjUT=FC+iF0AkDQsQ@mail.gmail.com>
Subject: Re: Linux kernel support -O0 optimization flag?
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Ley Foon Tan <lftan@altera.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Kenneth Chong Yin Tan <cytan@altera.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 9:58 AM, Ley Foon Tan <lftan@altera.com> wrote:
>
>
> Change KBUILD_CFLAGS to -O0 in Makefile and got the compilation error as
> below.
> Is the Linux kernel support -O0 optimization flag?

No. If I'm not mistaken we need this to make sure that the compiler
inlines some functions.

In your case the compiler failed to compute the BUILD_BUG() macro correctly.
It depends also on optimization.

--
Thanks,
//richard
