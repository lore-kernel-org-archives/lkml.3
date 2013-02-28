Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab3B1G1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 01:27:23 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:40740 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3B1G1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 01:27:22 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM=9twBA67kLADG4r51Q5me1AsLrHZeuTM4oSdkbKRmHGMtxA@mail.gmail.com>
References: <20130226030249.GB23834@kroah.com>
	<20130226031338.GA29784@srcf.ucam.org>
	<20130226033156.GA24999@kroah.com>
	<20130226033803.GA30285@srcf.ucam.org>
	<20130226035416.GA1128@kroah.com>
	<20130226040456.GA30717@srcf.ucam.org>
	<20130226041324.GA7241@kroah.com>
	<CAPM=9tzTXL_mystUa2=hGGzNZaYH==pMwt_PMLsWuqpRTs335g@mail.gmail.com>
	<20130226044521.GC12906@thunk.org>
	<20130226165451.GE32160@fenchurch.internal.datastacks.com>
	<20130227152429.GA5609@thunk.org>
	<CAPM=9twBA67kLADG4r51Q5me1AsLrHZeuTM4oSdkbKRmHGMtxA@mail.gmail.com>
Date: Thu, 28 Feb 2013 07:27:21 +0100
X-Google-Sender-Auth: s5d32VLfRMh3H0MhQ1S4cJEbx3Y
Message-ID: <CAMuHMdU=EiqCkogQcY46UV8LzdKgYF6eG1Q91oyytnzZMY9esQ@mail.gmail.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dave Airlie <airlied@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Peter Jones <pjones@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 10:31 PM, Dave Airlie <airlied@gmail.com> wrote:
> On Thu, Feb 28, 2013 at 1:24 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Tue, Feb 26, 2013 at 11:54:51AM -0500, Peter Jones wrote:
>>> No, no, no.  Quit saying nobody knows.  We've got a pretty good idea -
>>> we've got a contract with them, and it says they provide the signing
>>> service, and under circumstances where the thing being signed is found
>>> to enable malware that circumvents Secure Boot
>>
>> The question is what does "malware that circuments Secure Boot" mean?
>> Does starting up a hacked KVM and running Windows 8 under KVM so that
>> malare can be injected count as circumenting Secure Boot?  If so, will
>> you have to disable KVM, too?
>>
>> What if someone implements a virtualization bootkit for Windows 8.
>> Will they revoke their own key?  Somehow, I doubt that....
>
> Have you noticed that laptops rarely come with virtualisation enabled
> in the BIOS?
>
> Now you know why.

I thought it was about market segmentation? Charge $$$ for the model with VT
enabled.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
