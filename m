Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181Ab3BZDcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 22:32:10 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:57706 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758391Ab3BZDcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 22:32:06 -0500
MIME-Version: 1.0
In-Reply-To: <20130226032839.GA30164@srcf.ucam.org>
References: <87ppzo79in.fsf@mid.deneb.enyo.de>
	<30665.1361461678@warthog.procyon.org.uk>
	<CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
	<20130221164244.GA19625@srcf.ucam.org>
	<18738.1361836265@warthog.procyon.org.uk>
	<20130226005955.GA19686@kroah.com>
	<20130226023332.GA29282@srcf.ucam.org>
	<20130226030249.GB23834@kroah.com>
	<20130226031338.GA29784@srcf.ucam.org>
	<20130226032508.GA12906@thunk.org>
	<20130226032839.GA30164@srcf.ucam.org>
Date: Mon, 25 Feb 2013 19:32:04 -0800
X-Google-Sender-Auth: uCjXAaWGqOrmA0OuWi8-PKzkB24
Message-ID: <CA+55aFyVShz4T65VJ-1=V=OGwNNriyYf-aaomhDSMHOU7ZZqbA@mail.gmail.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 7:28 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
> You're happy advising Linux vendors that they don't need to worry about
> module signing because it's "not obvious" that Microsoft would actually
> enforce the security model they've spent significant money developing
> and advertising?

And you're happy shilling for a broken model?

The fact is, the only valid user for the whole security model is to
PROTECT THE USER.

Your arguments constantly seem to miss that rather big point. You
think this is about bending over when MS whispers sweet nothings in
your ear..

The whole and only reason I ever merged module signatures is because
it actually allows *users* to do a good job at security. You, on the
other hand, seem to have drunk the cool-aid on the whole "let's
control the user" crap.

Did you forget what security was all about?

              Linus
