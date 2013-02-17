Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab3BQL6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 06:58:16 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59738 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956Ab3BQL6P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 06:58:15 -0500
MIME-Version: 1.0
In-Reply-To: <5120B408.8030806@gmx.de>
References: <5120B408.8030806@gmx.de>
Date: Sun, 17 Feb 2013 12:58:13 +0100
Message-ID: <CAFLxGvw09tuOcwXN2kD0kH=SJ_-ho52aDS6Sut-z8dknGkPiqA@mail.gmail.com>
Subject: Re: shouldn't a non-privileged malformed sprintf crashes the kernel
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, boinc_dev@ssl.berkeley.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 11:42 AM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> This is the 2nd time in a row that a stable kernel (3.7.8 currently) crashes in such a way
> that even the sys-rq key doesn't work any longer.
> Found nothing in the log. The screen shot is here [1]. First time this issue was reported in [2].
>
> The bug seems to be triggered by the BOINC client - I'm running the alpha version of it [3].
>
> I'm wondering whether the sprintf issue discussed in [4] is the trigger for the bug
> (I attached that message here b/c the BOINC devs doesn't allow just even read access
> to the mail archive w/o registering).

Why "non-privileged malformed sprintf"? This makes no sense to me.
Your kernel crashed both times while reading from /proc/interrupts.

-- 
Thanks,
//richard
