Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab3BZWgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:36:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52501 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab3BZWgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:36:07 -0500
Date: Tue, 26 Feb 2013 22:35:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Peter Jones <pjones@redhat.com>
Cc: Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226223555.GK4503@ZenIV.linux.org.uk>
References: <20130226031338.GA29784@srcf.ucam.org>
 <20130226032508.GA12906@thunk.org>
 <20130226032839.GA30164@srcf.ucam.org>
 <CA+55aFyVShz4T65VJ-1=V=OGwNNriyYf-aaomhDSMHOU7ZZqbA@mail.gmail.com>
 <20130226034250.GB30285@srcf.ucam.org>
 <CA+55aFzn4KGKtn6cXN-jh9jgF+U1zJUnCmk6tRxmW8BZP7_Jnw@mail.gmail.com>
 <20130226034842.GD30285@srcf.ucam.org>
 <CA+55aFyAfgqmxGnh+WpZjgR5qKd+CLr1S7gKnXihqJXB346DqQ@mail.gmail.com>
 <87bob6pxtl.fsf@mid.deneb.enyo.de>
 <20130226214052.GJ32160@fenchurch.internal.datastacks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226214052.GJ32160@fenchurch.internal.datastacks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 04:40:53PM -0500, Peter Jones wrote:

> It prevents a form of malware which exists in the wild.  I think that's
> enough reason to want *something*, though SB isn't necessarily what
> we'd have dreamed of.  Nevertheless, SB is what we've got, and as such
> is why we've been working on how to use it meaningfully.

*snerk*

"We need to do something.  This is something.  Let's do it"
