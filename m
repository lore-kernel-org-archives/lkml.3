Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbbAZQph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:45:37 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:39017 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbbAZQpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:45:34 -0500
Date: Mon, 26 Jan 2015 08:44:57 -0800
From: christoph Hellwig <hch@infradead.org>
To: Tom Gundersen <teg@jklm.no>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Mack <daniel@zonque.org>, Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Kosina <jkosina@suse.cz>, Andy Lutomirski <luto@amacapital.net>,
        Linux API <linux-api@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>, Johannes Stezenbach <js@sig21.net>,
        "Theodore T'so" <tytso@mit.edu>, christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Message-ID: <20150126164457.GC22803@infradead.org>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
 <54BE5DC8.70706@gmail.com>
 <54BE9D08.7010804@zonque.org>
 <54BF805B.4000609@gmail.com>
 <54BFDAAA.50203@zonque.org>
 <54C0CE8A.5080805@gmail.com>
 <20150123155402.GB2159@kroah.com>
 <54C65267.7090905@gmail.com>
 <CAG-2HqUCZjc4Ucc-L21uG6e-di4UcLJAT5mW_-5-c-uqmoJyzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG-2HqUCZjc4Ucc-L21uG6e-di4UcLJAT5mW_-5-c-uqmoJyzA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 04:26:53PM +0100, Tom Gundersen wrote:
> The way I read this is that there will (probably) be a handful of
> users, namely the existing dbus libraries: libdus, sd-bus, glib, Qt,
> ell, and maybe a few others. However, third-party developers will not
> know/care about the details of kdbus, they'll just be coding against
> the dbus libraries as before (might be minor changes, but they
> certainly won't need to know anything about the kernel API). Similarly
> to how userspace developers now code against their libc of choice,
> rather than use kernel syscalls directly.

Which means we do need proper man pages and detailed documentation for
it, just like syscalls for syscalls which just happened to be used by
a few libcs.  I suspect it really should be implemented as
syscalls anyway, but we can leave that argument aside from now.  Good
documentation certainly helps with making that decision in an educated
way.
