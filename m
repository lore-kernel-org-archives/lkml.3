Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbaGAOtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:49:10 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:8778 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755703AbaGAOtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:49:09 -0400
Date: Tue, 1 Jul 2014 10:49:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUILD BUG][3.16-rc3] Error: too many copied sections (max =
 13)
Message-ID: <20140701104900.67567edf@gandalf.local.home>
In-Reply-To: <CALCETrUJUvhGN3hrECf9A=vHkHSNqZ2KtMyDnmrhb-uTpgP6Nw@mail.gmail.com>
References: <20140701000913.5ea51f77@gandalf.local.home>
	<CALCETrUJUvhGN3hrECf9A=vHkHSNqZ2KtMyDnmrhb-uTpgP6Nw@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014 22:09:18 -0700
Andy Lutomirski <luto@amacapital.net> wrote:

 
> I just successfully built your config, albeit with a different
> toolchain.  Can you do:
> 
> for i in arch/x86/vdso/*.so.dbg; do echo $i; eu-readelf -S $i; done
> 
> after a failed build?

I'll have to do this tomorrow. My boxes are occupied for other tasks
today.

-- Steve

> 
> Let the game of section whack-a-mole begin.
> 
> Thanks,
> Andy

