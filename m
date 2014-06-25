Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbaFYQ4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:56:14 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:59422 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667AbaFYQ4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:56:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140623074440.GV18016@ZenIV.linux.org.uk>
References: <20140621035144.GA8526@thunk.org>
	<20140621055306.GP18016@ZenIV.linux.org.uk>
	<20140621230922.GA13188@thunk.org>
	<20140621234913.GQ18016@ZenIV.linux.org.uk>
	<1403395400.2592.4.camel@jarvis.lan>
	<20140622002618.GR18016@ZenIV.linux.org.uk>
	<1403397164.2177.40.camel@dabdike.int.hansenpartnership.com>
	<20140622005352.GS18016@ZenIV.linux.org.uk>
	<20140622010032.GT18016@ZenIV.linux.org.uk>
	<20140622115007.GA5333@thunk.org>
	<20140623074440.GV18016@ZenIV.linux.org.uk>
Date: Wed, 25 Jun 2014 09:56:09 -0700
X-Google-Sender-Auth: WZaYRVFSnyeJwrTaAVm0ScP6oMs
Message-ID: <CA+55aFyEHiq4UVg=JHH5y=B8UefH8Y3QnrFcnmXy5uLnCDiZbQ@mail.gmail.com>
Subject: Re: [regression] fix 32-bit breakage in block device read(2) (was Re:
 32-bit bug in iovec iterator changes)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,
 just checking - did you expect me to take this from the email, or are
you preparing a pull request?

               Linus

On Mon, Jun 23, 2014 at 12:44 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> OK, here it is, hopefully with sufficient comments:
