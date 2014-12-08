Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbaLHNSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:18:18 -0500
Received: from relay04.alfahosting-server.de ([109.237.142.240]:58980 "EHLO
	relay04.alfahosting-server.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752885AbaLHNSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:18:14 -0500
X-Spam-DCC: : 
Date: Mon, 8 Dec 2014 14:18:37 +0100
From: Richard Leitner <dev@g0hl1n.net>
To: Arnd Bergmann <arnd@arndb.de>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc: ioc4: fix variable may be used uninitialized
 warning
Message-ID: <20141208141837.752a9968@frodo>
In-Reply-To: <4066664.BgJJnCmQ3h@wuerfel>
References: <20141208132720.16356743@frodo>
	<4066664.BgJJnCmQ3h@wuerfel>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Checker-Version: clamassassin 1.2.4 with ClamAV 0.97.3/19749/Mon Dec  8 12:41:14 2014
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Dec 2014 13:42:47 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 08 December 2014 13:27:20 Richard Leitner wrote:
> > 
> > As far as I can tell 'start' cannot really be used uninitialized
> > here, but for the sanity of gcc output explicitly initialize it.
> > Same goes for the 'end' variable.
> 
> Prabhakar Lad also sent a patch for this already, which was lacking
> a good patch description. Your patch does this slightly better but
> still fails to explain how you concluded it was safe and you don't
> really explain why you initialize the 'end' variable that we don't
> even get a warning about.

Oops, I'm sorry, I haven't seen the patch and the answers to it.

According to the comments by Andrew a simplification of this code
section would be nice. I think it should be possible to do this in a
way that the initialize-to-zero won't be needed anymore.

Prabhakar Lad, are you working on this already?
If not I'll take a look at it.

regards,
richard

