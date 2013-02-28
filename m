Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab3B1HsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 02:48:14 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:61514 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab3B1HsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 02:48:11 -0500
Message-ID: <512F0BB5.90009@redhat.com>
Date: Thu, 28 Feb 2013 08:48:05 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Dave Airlie <airlied@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Peter Jones <pjones@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
References: <20130226030249.GB23834@kroah.com> <20130226031338.GA29784@srcf.ucam.org> <20130226033156.GA24999@kroah.com> <20130226033803.GA30285@srcf.ucam.org> <20130226035416.GA1128@kroah.com> <20130226040456.GA30717@srcf.ucam.org> <20130226041324.GA7241@kroah.com> <CAPM=9tzTXL_mystUa2=hGGzNZaYH==pMwt_PMLsWuqpRTs335g@mail.gmail.com> <20130226044521.GC12906@thunk.org> <20130226165451.GE32160@fenchurch.internal.datastacks.com> <20130227152429.GA5609@thunk.org> <CAPM=9twBA67kLADG4r51Q5me1AsLrHZeuTM4oSdkbKRmHGMtxA@mail.gmail.com> <CAMuHMdU=EiqCkogQcY46UV8LzdKgYF6eG1Q91oyytnzZMY9esQ@mail.gmail.com>
In-Reply-To: <CAMuHMdU=EiqCkogQcY46UV8LzdKgYF6eG1Q91oyytnzZMY9esQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 28/02/2013 07:27, Geert Uytterhoeven ha scritto:
> I thought it was about market segmentation? Charge $$$ for the model with VT
> enabled.

No, there's the Atom that doesn't come with virtualization extensions at
all.

But things like Bluepill are the reason why you have to enable VT manually.

Paolo

> Gr{oetje,eeting}s,
> 
>                         Geert

