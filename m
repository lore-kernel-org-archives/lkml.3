Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab3BYOdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 09:33:17 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:35800 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982Ab3BYOdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 09:33:16 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
References: <CA+55aFy4k07GPmszkBdYvCE-KphKLVowkZoW7hoAvcR+0U=stg@mail.gmail.com>
	<30665.1361461678@warthog.procyon.org.uk>
	<CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
	<20130221164244.GA19625@srcf.ucam.org>
	<567.1361470653@warthog.procyon.org.uk>
	<20130221182511.GA22156@srcf.ucam.org>
Date: Mon, 25 Feb 2013 15:33:12 +0100
In-Reply-To: <20130221182511.GA22156@srcf.ucam.org> (Matthew Garrett's message
	of "Thu, 21 Feb 2013 18:25:11 +0000")
Message-ID: <878v6c79av.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett:

> I don't think that's a problem. Just put the original binary hash in the 
> certificate before signing it, and extend the X.509 parser to refuse 
> certificates that have a tag that's present in dbx.

Why would Microsoft put a hash of something into dbx which they
haven't signed?  Wouldn't this make them subject to a
denial-of-service attack on their platform if they revoke something
with surprising consequences?
