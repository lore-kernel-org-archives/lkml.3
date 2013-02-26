Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab3BZVkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 16:40:21 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:38195 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228Ab3BZVkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 16:40:20 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Chris Friesen <chris.friesen@genband.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Peter Jones <pjones@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
References: <30665.1361461678@warthog.procyon.org.uk>
	<CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
	<20130221164244.GA19625@srcf.ucam.org>
	<CA+55aFy4k07GPmszkBdYvCE-KphKLVowkZoW7hoAvcR+0U=stg@mail.gmail.com>
	<20130221174955.GA20886@srcf.ucam.org>
	<CA+55aFxZ4f4KiHQBCAgTghm+deniS6rDz4wna9bce6vK8WppsA@mail.gmail.com>
	<20130222140539.GE20629@fenchurch.internal.datastacks.com>
	<877glw78p5.fsf@mid.deneb.enyo.de>
	<20130225154215.GB13605@srcf.ucam.org>
	<87obf85r51.fsf@mid.deneb.enyo.de>
	<20130225161435.GA18404@srcf.ucam.org> <512B8F40.9090902@genband.com>
Date: Tue, 26 Feb 2013 22:40:02 +0100
In-Reply-To: <512B8F40.9090902@genband.com> (Chris Friesen's message of "Mon,
	25 Feb 2013 10:20:16 -0600")
Message-ID: <871uc2pxe5.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Friesen:

> On 02/25/2013 10:14 AM, Matthew Garrett wrote:
>> Windows 8 will not load unsigned drivers if Secure Boot is enabled.
>
> For reference:
>
> http://msdn.microsoft.com/en-us/library/windows/desktop/hh848062%28v=vs.85%29.aspx

Thanks.  Do you know perchance of any other Microsoft documentation in
this area, that is, their PKI architecture, the signing and revocation
policies, or even security objectives for the Secure Boot
implementation?

The Windows 8 logo requirements are pretty thin on this and only
specify the "Microsoft Windows Production PCA 2011" (which is used to
sign the Windows boot loader).  Policy-wise, I've seen very little
published information (most of it is hearsay), and as to the
objectives, I'm really in the dark.
