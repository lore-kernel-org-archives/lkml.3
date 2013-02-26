Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab3BZKVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 05:21:24 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:56767 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab3BZKVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 05:21:22 -0500
Date: Tue, 26 Feb 2013 10:21:11 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Raymond Jennings <shentino@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Dave Airlie <airlied@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226102111.GA4229@srcf.ucam.org>
References: <20130226033803.GA30285@srcf.ucam.org>
 <20130226035416.GA1128@kroah.com>
 <20130226040456.GA30717@srcf.ucam.org>
 <20130226041324.GA7241@kroah.com>
 <CAPM=9tzTXL_mystUa2=hGGzNZaYH==pMwt_PMLsWuqpRTs335g@mail.gmail.com>
 <20130226044521.GC12906@thunk.org>
 <CAPM=9tygczL81L_t=uJs3bAae_h96iGkxWK-qYfcWkcCzOjsXw@mail.gmail.com>
 <20130226060428.GD12906@thunk.org>
 <20130226063813.GA17317@thunk.org>
 <CAGDaZ_rkxQFDfJXdoPSXMx6hk21t0jPM4p+KQsLfvPWScofWag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGDaZ_rkxQFDfJXdoPSXMx6hk21t0jPM4p+KQsLfvPWScofWag@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 02:07:22AM -0800, Raymond Jennings wrote:
> Just curious here, but is this as much of an issue if a user is
> somehow able to take ownership of his own machine?

No, if you're doing your own key management then it's no problem at 
all.

> I'm assuming this is related to TPM somehow.

No, completely unrelated.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
