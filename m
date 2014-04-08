Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbaDHTDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 15:03:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548AbaDHTC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 15:02:58 -0400
Date: Tue, 8 Apr 2014 12:02:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/8 v4] printk: Cleanups and softlockup avoidance
Message-Id: <20140408120256.d0e838a441cfcc8e9d65a62b@linux-foundation.org>
In-Reply-To: <20140408142726.GB9551@quack.suse.cz>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
	<20140408142726.GB9551@quack.suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2014 16:27:26 +0200 Jan Kara <jack@suse.cz> wrote:

> On Tue 25-03-14 18:54:53, Jan Kara wrote:
> >   Hello,
> > 
> >   this is another revision of the printk softlockup series.
> > 
> > Changes since v3:
> > Fixed bogus warning in console_try_lock_spin() in non-preemptible kernels.
> > Fixed infinite loop in console_flush() when console was suspended.
> > 
> > Changes since v2:
> > I have fixed up some small problems pointed out by Andrew, added possibility to
> > configure out the printk offloading logic (for small systems), and offload
> > kthreads are now started only once printk.offload_chars is set to value > 0.
> > 
> > Intro for the newcomers to the series below.
>   Ping Andrew?

I buffer up new material before and during the merge window.  Uncorkage
will happen later this week.
