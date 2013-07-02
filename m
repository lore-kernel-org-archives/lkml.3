Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab3GBH35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 03:29:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46291 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab3GBH3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 03:29:55 -0400
Date: Tue, 2 Jul 2013 09:29:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ingo Molnar <mingo@kernel.org>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130702072950.GA4036@Nokia-N900>
References: <20130620180808.GB19877@pd.tnic>
 <20130620181015.GA27833@srcf.ucam.org>
 <20130620181445.GA791@pd.tnic>
 <20130620181731.GA27960@srcf.ucam.org>
 <20130620184736.GC19877@pd.tnic>
 <51C383AC.4060706@zytor.com>
 <20130621072356.GA22006@pd.tnic>
 <ca8f8134-24d9-4f96-8876-e24892efc849@email.android.com>
 <20130621142101.GG22006@pd.tnic>
 <51C4827B.7090208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C4827B.7090208@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2013-06-21 09:42:35, H. Peter Anvin wrote:
> On 06/21/2013 07:21 AM, Borislav Petkov wrote:
> > On Fri, Jun 21, 2013 at 03:05:30AM -0700, H. Peter Anvin wrote:
> >> If you cap it you are basically imposing a constraint on the firmware
> >> and may not run properly (or at least have to turn off EFI runtime
> >> calls with all that implies.)
> > 
> > I don't want to cap EFI just for the fun of it but rather set a limit
> > so that the next one who wants a chunk of the virtual address space can
> > have a reliable limit from where she/he can start. Otherwise we won't
> > know where EFI reliably ends...
> > 
> 
> We don't... and I don't think there is anything we can do about it.  If
> some messed-up firmware wants to map a terabyte we either refuse and
> don't allow EFI runtime calls on that machine or we accept it.
> 
> Fortunately the space is extremely large and with growing down from a
> known address it is less likely that we'll conflict with something.

Hmm, will not setting up huge areas be slow?

Or we are going to use 2G pages or something?

Or should we make it slow on purpose so that at least server
vendors are discouraged from using big areas? :-)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
