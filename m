Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab3BYPu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 10:50:57 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:42889 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759895Ab3BYPu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 10:50:56 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Peter Jones <pjones@redhat.com>,
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
Date: Mon, 25 Feb 2013 16:50:50 +0100
In-Reply-To: <20130225154215.GB13605@srcf.ucam.org> (Matthew Garrett's message
	of "Mon, 25 Feb 2013 15:42:15 +0000")
Message-ID: <87obf85r51.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett:

> On Mon, Feb 25, 2013 at 03:46:14PM +0100, Florian Weimer wrote:
>
>> You could just drop the requirement that ring 0 code must be signed.
>> I don't think Windows 8 enforces this, but I'm not yet sure if there
>> is a physical presence check before you can enter a mode in which
>> Windows loads self-signed kernel modules.
>
> Windows 8 will not load unsigned drivers if Secure Boot is enabled.

What about "bcdedit /set ... testsigning on"?
