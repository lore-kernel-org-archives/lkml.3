Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921Ab3BZTlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 14:41:05 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:52495 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758329Ab3BZTlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 14:41:03 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dave Airlie <airlied@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
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
Date: Tue, 26 Feb 2013 20:40:53 +0100
In-Reply-To: <20130226044521.GC12906@thunk.org> (Theodore Ts'o's message of
	"Mon, 25 Feb 2013 23:45:21 -0500")
Message-ID: <87621esw1m.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Theodore Ts'o:

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

| No, there's no way to set the legacy boot as the default option.

<https://plus.google.com/100479847213284361344/posts/QhmBpn5GNE9>

So non-interactive booting of alternative operating systems is *not*
supported.  This is way more restrictive than any x86 UEFI device I've
heard of (even in the face of a potential revocation of the boot
loader by Microsoft).
