Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab3B0VcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 16:32:00 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:52679 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab3B0Vb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 16:31:59 -0500
MIME-Version: 1.0
In-Reply-To: <20130227152429.GA5609@thunk.org>
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
Date: Thu, 28 Feb 2013 07:31:57 +1000
Message-ID: <CAPM=9twBA67kLADG4r51Q5me1AsLrHZeuTM4oSdkbKRmHGMtxA@mail.gmail.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
From: Dave Airlie <airlied@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Peter Jones <pjones@redhat.com>,
        Dave Airlie <airlied@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 1:24 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Feb 26, 2013 at 11:54:51AM -0500, Peter Jones wrote:
>> No, no, no.  Quit saying nobody knows.  We've got a pretty good idea -
>> we've got a contract with them, and it says they provide the signing
>> service, and under circumstances where the thing being signed is found
>> to enable malware that circumvents Secure Boot
>
> The question is what does "malware that circuments Secure Boot" mean?
> Does starting up a hacked KVM and running Windows 8 under KVM so that
> malare can be injected count as circumenting Secure Boot?  If so, will
> you have to disable KVM, too?
>
> What if someone implements a virtualization bootkit for Windows 8.
> Will they revoke their own key?  Somehow, I doubt that....

Have you noticed that laptops rarely come with virtualisation enabled
in the BIOS?

Now you know why.

Dave.
