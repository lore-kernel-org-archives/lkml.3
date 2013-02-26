Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3BZWGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:06:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab3BZWGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:06:33 -0500
Date: Tue, 26 Feb 2013 17:06:19 -0500
From: Peter Jones <pjones@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Josh Boyer <jwboyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226220618.GK32160@fenchurch.internal.datastacks.com>
References: <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226033156.GA24999@kroah.com>
 <20130226033803.GA30285@srcf.ucam.org>
 <20130226035416.GA1128@kroah.com>
 <20130226040456.GA30717@srcf.ucam.org>
 <20130226041324.GA7241@kroah.com>
 <20130226042338.GA30944@srcf.ucam.org>
 <CA+55aFx9HkRGfMx6pfR2xsTf0vof_yyrT4ks5TzMKoEpS7w=5g@mail.gmail.com>
 <CAMuHMdV4DbX_i6Ye5v7ObR0no-eDhBzqYrsqVtR5PAXQTVSmVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMuHMdV4DbX_i6Ye5v7ObR0no-eDhBzqYrsqVtR5PAXQTVSmVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 10:57:38PM +0100, Geert Uytterhoeven wrote:

> BTW, I assume UEFI checks itself if enrolled hashes have been revoked,
> so it must phone home to some server? That must be disabled as well.

No.  Quit fearmongering.

--
	Peter
