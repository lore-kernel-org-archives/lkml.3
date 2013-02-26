Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232Ab3BZEzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 23:55:35 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46153 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab3BZEze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 23:55:34 -0500
MIME-Version: 1.0
In-Reply-To: <20130226044521.GC12906@thunk.org>
References: <20130226005955.GA19686@kroah.com>
	<20130226023332.GA29282@srcf.ucam.org>
	<20130226030249.GB23834@kroah.com>
	<20130226031338.GA29784@srcf.ucam.org>
	<20130226033156.GA24999@kroah.com>
	<20130226033803.GA30285@srcf.ucam.org>
	<20130226035416.GA1128@kroah.com>
	<20130226040456.GA30717@srcf.ucam.org>
	<20130226041324.GA7241@kroah.com>
	<CAPM=9tzTXL_mystUa2=hGGzNZaYH==pMwt_PMLsWuqpRTs335g@mail.gmail.com>
	<20130226044521.GC12906@thunk.org>
Date: Tue, 26 Feb 2013 14:55:32 +1000
Message-ID: <CAPM=9tygczL81L_t=uJs3bAae_h96iGkxWK-qYfcWkcCzOjsXw@mail.gmail.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
From: Dave Airlie <airlied@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Dave Airlie <airlied@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 2:45 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Feb 26, 2013 at 02:25:55PM +1000, Dave Airlie wrote:
>>
>> Its a simple argument, MS can revoke our keys for whatever reason,
>> reducing the surface area of reasons for them to do so seems like a
>> good idea. Unless someone can read the mind of the MS guy that
>> arbitrarily decides this in 5 years time, or has some sort of signed
>> agreement, I tend towards protecting the users from having their Linux
>> not work anymore, because we were scared of a PE loader in the kernel.
>
> If Microsoft will revoke keys for whatever reason they want, without
> any regard to the potential PR and legal consequences to Microsoft,
> there's absolutely **nothing** you can do, short of choosing to use
> more open hardware (for example, like the Chromebook Pixel).
>
> If you're that terrified of the completely arbitrary and capricious
> Microsoft guy having us by the short hairs, why aid and abet Microsoft
> control-freak model?
>

No what I said if you read it, was nobody knows, you don't, Greg
doesn't, Matthew doesn't.

That's the problem you are all arguing like you know shit that none of you know.

So you all have opinions on what Microsoft would do if faced with the
compromise Matthew reports, and really if you think MS are going to
leave a secureboot bypass via Linux live, then you wonder why they are
expending all this money on secureboot at all, since the first person
to write a Linux based exploit is safe because of a PR backlash? At
this point we'd be best served by writing the PoC exploit I suppose
and then seeing what MS do up front!

So it would be nice if LF could undertake to go and talk to Microsoft,
and get vague opinions turned into something real.

Ted you might be at liberty to get a chromebook pixel from google, but
that isn't going to help the other X% of users who have a PC they want
to use Linux on, and maybe boot Windows to do their taxes.

Dave.
