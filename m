Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbaLHP5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:57:49 -0500
Received: from relay01.alfahosting-server.de ([109.237.142.236]:39147 "EHLO
	relay01.alfahosting-server.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754953AbaLHP5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:57:48 -0500
X-Spam-DCC: : 
Date: Mon, 8 Dec 2014 16:58:17 +0100
From: Richard Leitner <dev@g0hl1n.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] misc: ioc4: simplify wave period measurement in
 clock_calibrate
Message-ID: <20141208165817.52d03794@frodo>
In-Reply-To: <3564575.fggPKDmMEE@wuerfel>
References: <20141208132720.16356743@frodo>
	<CA+V-a8tww3bt7rhMT8Bxn0dwyg4qQTeVKbAKKJxh__zXrKrewA@mail.gmail.com>
	<20141208162810.7b009382@frodo>
	<3564575.fggPKDmMEE@wuerfel>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Checker-Version: clamassassin 1.2.4 with ClamAV 0.97.3/19749/Mon Dec  8 12:41:14 2014
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Dec 2014 16:46:31 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 08 December 2014 16:28:10 Richard Leitner wrote:
> > 
> > Signed-off-by: Richard Leitner <dev@g0hl1n.net>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> 
> With the changed loop, do you still get a warning if you
> remove the extra 'start = ktime_get_ns()' at the start of the loop?
> 
Yes. Although IOC4_CALIBRATE_DISCARD is smaller than IOC4_CALIBRATE_END
and there's no more break in the loop, it seems gcc doesn't get it...

regards,
richard

