Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836Ab3BZEZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 23:25:58 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:45057 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759729Ab3BZEZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 23:25:56 -0500
MIME-Version: 1.0
In-Reply-To: <20130226041324.GA7241@kroah.com>
References: <20130221164244.GA19625@srcf.ucam.org>
	<18738.1361836265@warthog.procyon.org.uk>
	<20130226005955.GA19686@kroah.com>
	<20130226023332.GA29282@srcf.ucam.org>
	<20130226030249.GB23834@kroah.com>
	<20130226031338.GA29784@srcf.ucam.org>
	<20130226033156.GA24999@kroah.com>
	<20130226033803.GA30285@srcf.ucam.org>
	<20130226035416.GA1128@kroah.com>
	<20130226040456.GA30717@srcf.ucam.org>
	<20130226041324.GA7241@kroah.com>
Date: Tue, 26 Feb 2013 14:25:55 +1000
Message-ID: <CAPM=9tzTXL_mystUa2=hGGzNZaYH==pMwt_PMLsWuqpRTs335g@mail.gmail.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
From: Dave Airlie <airlied@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, David Howells <dhowells@redhat.com>,
        Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Right. We've failed at creating an alternative. That doesn't mean that
>> we get to skip the responsibilities associated with the choice we've
>> made.
>
> Wait, who is "we" here?  The community?  The community over-all didn't
> agree with anything with Microsoft, that is between the people getting a
> signed key and Microsoft.  Again, you are trying to push your (prior)
> company's agreement between them and Microsoft onto the community, and
> now the community is pushing back, is that a surprise?

Do you not work for the LF?, Matthew doesn't work for RH, so please
leave the petty my employer said this, and he's better than your
employer and try and stick to technical details.

Maybe the LF can do something useful and get MS to sign an agreement
saying we don't require any of this extra security stuff and that if
Linux is used to root Windows Secureboot platforms, they won't revoke
the key for our bootloaders. Until then you aren't providing anything
more technical than FUD.

Its a simple argument, MS can revoke our keys for whatever reason,
reducing the surface area of reasons for them to do so seems like a
good idea. Unless someone can read the mind of the MS guy that
arbitrarily decides this in 5 years time, or has some sort of signed
agreement, I tend towards protecting the users from having their Linux
not work anymore, because we were scared of a PE loader in the kernel.

Dave.
