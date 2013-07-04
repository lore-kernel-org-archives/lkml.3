Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab3GDRWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 13:22:13 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:51655 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab3GDRWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 13:22:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130704074902.GA32211@redhat.com>
References: <20130704015525.GA8486@redhat.com>
	<CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com>
	<20130704074902.GA32211@redhat.com>
Date: Thu, 4 Jul 2013 10:22:09 -0700
X-Google-Sender-Auth: FzCrCc0MN5MuS6D8CSFiS8rx7l4
Message-ID: <CA+55aFz+Bo+MGMmUsuxb2uHRNBUvKEdQqR7nZTTQdHOtgnVkDw@mail.gmail.com>
Subject: Re: scheduling while atomic & hang.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Anvin <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 4, 2013 at 12:49 AM, Dave Jones <davej@redhat.com> wrote:
>
> top of tree was 0b0585c3e192967cb2ef0ac0816eb8a8c8d99840 I think.
> (That's what it is on my local box that I pull all my test trees from,
> and I don't think it changed after I started that run, but I'll
> double check on Friday)

Ok. So that has all the scheduler changes, and all the x86 changes
(and all the cgroup workqueue changes too - but without any call chain
at all, I'm disinclined to blame those yet).

> I don't use the auto config, because I end up filling up /boot
> unless I go through and clean them out by hand every time I install
> a new one (which I do probably a dozen or so times a day).
> Is there some easy way to prune old builds I'm missing ?

I'm sure it could be done automatically some way, but yeah, I just do
it by hand. I often *compile* dozens of kernels a day, but I seldom
install more than one or two even during the merge window..

              Linus
