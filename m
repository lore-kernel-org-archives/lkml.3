Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab3BZQqC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 11:46:02 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:37824 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758829Ab3BZQqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 11:46:00 -0500
MIME-Version: 1.0
In-Reply-To: <20130226102111.GA4229@srcf.ucam.org>
References: <20130226033803.GA30285@srcf.ucam.org> <20130226035416.GA1128@kroah.com>
 <20130226040456.GA30717@srcf.ucam.org> <20130226041324.GA7241@kroah.com>
 <CAPM=9tzTXL_mystUa2=hGGzNZaYH==pMwt_PMLsWuqpRTs335g@mail.gmail.com>
 <20130226044521.GC12906@thunk.org> <CAPM=9tygczL81L_t=uJs3bAae_h96iGkxWK-qYfcWkcCzOjsXw@mail.gmail.com>
 <20130226060428.GD12906@thunk.org> <20130226063813.GA17317@thunk.org>
 <CAGDaZ_rkxQFDfJXdoPSXMx6hk21t0jPM4p+KQsLfvPWScofWag@mail.gmail.com> <20130226102111.GA4229@srcf.ucam.org>
From: Kent Yoder <shpedoikal@gmail.com>
Date: Tue, 26 Feb 2013 10:45:27 -0600
Message-ID: <CAM0nabEQeezsg_KTX03-qVohXGX=8ZeW7ipFGn-e5_xfoTFXFw@mail.gmail.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Raymond Jennings <shentino@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Dave Airlie <airlied@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 4:21 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Feb 26, 2013 at 02:07:22AM -0800, Raymond Jennings wrote:
>> Just curious here, but is this as much of an issue if a user is
>> somehow able to take ownership of his own machine?
>
> No, if you're doing your own key management then it's no problem at
> all.
>
>> I'm assuming this is related to TPM somehow.
>
> No, completely unrelated.

  Almost completely.  As Matthew I'm sure knows, TPM is also used to
establish a chain of trust, but not using signed
firmware/kernel/modules, but chained hashes that are later signed
using the TPM.  It does avoid the issue of embedding keys from a
centralized authority in your box's firmware.

Kent

> --
> Matthew Garrett | mjg59@srcf.ucam.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
