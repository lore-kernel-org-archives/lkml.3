Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaEAVFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:05:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57200 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaEAVFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:05:24 -0400
Date: Thu, 1 May 2014 22:05:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140501210522.GC18016@ZenIV.linux.org.uk>
References: <CA+55aFzekh6peA627B1e3NwcL06DqErWX6whJGm4w0WDRTn1gA@mail.gmail.com>
 <CA+55aFwafZjeCEjaiAxCxQ1L9f6wBYXFsJQoSgr3681Y7=ER5w@mail.gmail.com>
 <20140430234341.GX18016@ZenIV.linux.org.uk>
 <CA+55aFyb7TPkOXmOiNQojnW-Fb-uunbqdMgiF13hE-o1t5rmcQ@mail.gmail.com>
 <20140501025105.GY18016@ZenIV.linux.org.uk>
 <CA+55aFzN=ERrtWUwAQv0ry-ZzX2k7dz3JZQT6q5zjp_ABwMg6Q@mail.gmail.com>
 <20140501031251.GZ18016@ZenIV.linux.org.uk>
 <20140501094252.GE3113@tucsk.piliscsaba.szeredi.hu>
 <20140501143434.GA18016@ZenIV.linux.org.uk>
 <20140501210233.GB18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501210233.GB18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 10:02:33PM +0100, Al Viro wrote:
> *grumble*
> 
> Looks like gmail filtering is buggered again.  The previous mail got
> bounced by gmail, both for Miklos and for Linus ;-/  Hell knows if
> this one gets through; the original is at http://lkml.org/lkml/2014/5/1/235,
> bounce being bloody vague, as usual.

... and so has this one, the bounce being

[quote]
A message that you sent could not be delivered to one or more of its
recipients. This is a permanent error. The following address(es) failed:

  torvalds@linux-foundation.org
    SMTP error from remote mail server after end of data:
    host ASPMX.L.GOOGLE.COM [173.194.67.27]: 550-5.7.1 [195.92.253.2      12] Our system has detected that this message is
    550-5.7.1 likely unsolicited mail. To reduce the amount of spam sent to Gmail,
    550-5.7.1 this message has been blocked. Please visit
    550-5.7.1 http://support.google.com/mail/bin/answer.py?hl=en&answer=188131 for
    550 5.7.1 more information. cv1si45381wib.71 - gsmtp
  miklos@szeredi.hu
    SMTP error from remote mail server after end of data:
    host ASPMX.L.GOOGLE.COM [173.194.67.27]: 550-5.7.1 [195.92.253.2      12] Our system has detected that this message is
    550-5.7.1 likely unsolicited mail. To reduce the amount of spam sent to Gmail,
    550-5.7.1 this message has been blocked. Please visit
    550-5.7.1 http://support.google.com/mail/bin/answer.py?hl=en&answer=188131 for
    550 5.7.1 more information. bb7si53528wib.20 - gsmtp
[endquote]

What the hell is going on?
