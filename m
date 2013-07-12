Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965489Ab3GLVCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 17:02:21 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:62770 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965359Ab3GLVCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 17:02:19 -0400
Date: Fri, 12 Jul 2013 14:02:20 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Theodore Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130712210220.GA8872@roeck-us.net>
References: <20130711214830.611455274@linuxfoundation.org>
 <20130711222935.GA11340@redhat.com>
 <20130711224455.GA17222@kroah.com>
 <20130712141530.GA3629@roeck-us.net>
 <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
 <20130712173150.GA5534@roeck-us.net>
 <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
 <20130712195051.GB32054@1wt.eu>
 <20130712204744.GD342@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712204744.GD342@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 04:47:44PM -0400, Theodore Ts'o wrote:
> On Fri, Jul 12, 2013 at 09:50:51PM +0200, Willy Tarreau wrote:
> > So probably we should incite patch contributors to add a specific
> > tag such as "Fixes: 3.5 and later", so that non-important patches
> > do not need the Cc:stable anymore, but users who experience an issue
> > can easily spot them and ask for their inclusion.
> 
> This is a really good idea.   /me likes....
> 
I agree, that would be very helpful.

Guenter
