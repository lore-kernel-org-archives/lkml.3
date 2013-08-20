Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab3HTUTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:19:55 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:54320 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3HTUTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:19:53 -0400
Date: Tue, 20 Aug 2013 13:19:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net
Subject: Re: Linux 3.0.92
Message-ID: <20130820201950.GB2524@roeck-us.net>
References: <20130820155735.GA2805@kroah.com>
 <CA+55aFxrPP8=xPWuRVy0HPyiFkT8Mc03zWGKosg+WrEQfqNDfQ@mail.gmail.com>
 <20130820164343.GA3958@kroah.com>
 <20130820200035.GA2524@roeck-us.net>
 <CA+55aFwVmDVfrL+Xhkk+AZf5iZdWunQaMeRGLJ0yKeBh9brTQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwVmDVfrL+Xhkk+AZf5iZdWunQaMeRGLJ0yKeBh9brTQQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 01:08:28PM -0700, Linus Torvalds wrote:
> On Tue, Aug 20, 2013 at 1:00 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> >>
> > Does this patch have to be reverted in 3.10 as well ? Linus' e-mail seems to
> > suggest it, but Shuah didn't see the problem there.  I ran a quick test with
> > 3.10.8 on an x86 system and did not see a problem either, at least not
> > immediately.
> 
> Do you run with lockdep?
> 
> The patch causes a _possibility_ of a deadlock, but unless you have
> lockdep enabled, you're almost guaranteed to not actually ever see
> that deadlock in practice.
> 
I have CONFIG_LOCKDEP_SUPPORT enabled. Guess I need CONFIG_LOCKUP_DETECTOR as
well. I'll give it a try.

Guenter
