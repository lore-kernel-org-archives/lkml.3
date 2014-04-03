Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaDCSE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:04:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaDCSEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:04:21 -0400
Date: Thu, 3 Apr 2014 11:06:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tim Bird <tbird20d@gmail.com>
Cc: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
Message-ID: <20140403180644.GD21565@kroah.com>
References: <20140402144219.4cafbe37@gandalf.local.home>
 <20140402221212.GD16570@mguzik.redhat.com>
 <CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
 <alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz>
 <yw1x7g76k62z.fsf@unicorn.mansr.com>
 <CA+bK7J57f8mHC0=UWrFG1MyyURb2hU6p2K1RTsHoWRNUz9LWLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+bK7J57f8mHC0=UWrFG1MyyURb2hU6p2K1RTsHoWRNUz9LWLw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 08:17:33AM -0700, Tim Bird wrote:
> 
> I had no idea systemd was so verbose and was abusing the kernel
> log buffers so badly.  I'm not a big fan of the rate-limiting, as this just
> seems to encourage this kind of abuse.

That was a bug in systemd, and has been fixed up in the latest versions,
so it shouldn't happen anymore, even with debugging enabled.

thanks,

greg k-h
