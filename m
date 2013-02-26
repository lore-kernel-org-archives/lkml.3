Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab3BZKIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 05:08:06 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:51681 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759926Ab3BZKIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 05:08:04 -0500
MIME-Version: 1.0
In-Reply-To: <20130226063813.GA17317@thunk.org>
References: <20130226031338.GA29784@srcf.ucam.org> <20130226033156.GA24999@kroah.com>
 <20130226033803.GA30285@srcf.ucam.org> <20130226035416.GA1128@kroah.com>
 <20130226040456.GA30717@srcf.ucam.org> <20130226041324.GA7241@kroah.com>
 <CAPM=9tzTXL_mystUa2=hGGzNZaYH==pMwt_PMLsWuqpRTs335g@mail.gmail.com>
 <20130226044521.GC12906@thunk.org> <CAPM=9tygczL81L_t=uJs3bAae_h96iGkxWK-qYfcWkcCzOjsXw@mail.gmail.com>
 <20130226060428.GD12906@thunk.org> <20130226063813.GA17317@thunk.org>
From: Raymond Jennings <shentino@gmail.com>
Date: Tue, 26 Feb 2013 02:07:22 -0800
Message-ID: <CAGDaZ_rkxQFDfJXdoPSXMx6hk21t0jPM4p+KQsLfvPWScofWag@mail.gmail.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
To: "Theodore Ts'o" <tytso@mit.edu>, Dave Airlie <airlied@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just curious here, but is this as much of an issue if a user is
somehow able to take ownership of his own machine?

I'm assuming this is related to TPM somehow.
