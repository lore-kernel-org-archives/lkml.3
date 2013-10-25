Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab3JYJcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 05:32:18 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:36246 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3JYJcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 05:32:17 -0400
MIME-Version: 1.0
In-Reply-To: <20131025022937.12623dcd.akpm@linux-foundation.org>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
	<CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
	<1814253454.3449.1382689853825.JavaMail.mail@webmail07>
	<20131025091842.GA28681@thunk.org>
	<20131025022937.12623dcd.akpm@linux-foundation.org>
Date: Fri, 25 Oct 2013 10:32:16 +0100
X-Google-Sender-Auth: Opy72cm7zev4qzYO7PtIp8EuQQU
Message-ID: <CA+55aFzq4-wsErRO56gW6gj3Q91QtvvaGQPdUV2JkSs-B1PCAQ@mail.gmail.com>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, "Artem S. Tashkinov" <t.artem@lycos.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 10:29 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Apparently all this stuff isn't working as desired (and perhaps as designed)
> in this case.  Will take a look after a return to normalcy ;)

It definitely doesn't work. I can trivially reproduce problems by just
having a cheap (==slow) USB key with an ext3 filesystem, and going a
git clone to it. The end result is not pretty, and that's actually not
even a huge amount of data.

                 Linus
