Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaHOQvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:51:43 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:36198 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbaHOQvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:51:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140815153353.GG17769@csclub.uwaterloo.ca>
References: <20140814222119.GD18411@ld-irv-0074>
	<20140815153353.GG17769@csclub.uwaterloo.ca>
Date: Fri, 15 Aug 2014 18:51:38 +0200
X-Google-Sender-Auth: m1rnlc2GVbcIeV-FckgobTamWwk
Message-ID: <CAMuHMdXicLNuBy+vkGFaaMYrK5OivkpLJaPmCkYZx33P_abHfw@mail.gmail.com>
Subject: Re: Overriding -Werror
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 5:33 PM, Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
> On Thu, Aug 14, 2014 at 03:21:19PM -0700, Brian Norris wrote:
>> I'm interested in being able to build-test kernels on various
>> architectures while enabling extra warnings (make W=[123]). I'd like to
>> be able to finish the builds and see all warnings, rather than seeing a
>> failed build. However, GCC's -Werror is incompatible with this. There is
>> plenty of code that will produce at least one warning, when warning
>> verbosity is turned up. And GCC's -Werror is not guaranteed to remain
>> stable over time; new versions may develop new warnings that may or may
>> not be legitimate.
>
> What ever is wrong with using '-k' with your make command?

While -k helps to get more compiled, and thus see more warnings, you'll still
be missing the report of missing symbols in the final link/modpost stage.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
