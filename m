Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab3FFAfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 20:35:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41633 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab3FFAfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 20:35:23 -0400
Date: Wed, 5 Jun 2013 17:35:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, linux-arm-kernel@lists.infradead.org,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        debian-kernel@lists.debian.org
Subject: Re: getting allwinner SoC support upstream (was Re: Uploading linux
 (3.9.4-1))
Message-ID: <20130606003553.GA7017@kroah.com>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
 <CAKON4OyyRF4Z46RyJFDWUwo4L52Z8bgSH0CzDr2gDerw4iDwcw@mail.gmail.com>
 <3619282.JgdgeGHudI@flatron>
 <CAPweEDwyX4=Sme9kyDU64k9h3SPUHuErD8gEqfdYLGwBOocZDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPweEDwyX4=Sme9kyDU64k9h3SPUHuErD8gEqfdYLGwBOocZDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 11:56:43PM +0100, Luke Kenneth Casson Leighton wrote:
> so there's a lot of factors which i believe the linux kernel
> developers are not aware of, and haven't taken into account, and to
> place blame onto the SoC vendors for not working with *you* when *you*
> haven't made an effort to understand their situation is, i feel, not
> really helping anyone.  not that i'm one to talk about understanding
> people, but hey... :)

Wait, everyone in the world knows where we (Linux kernel developers)
are, and how to contact us, how are we supposed to know we are supposed
to go after these various companies and contact them directly?

So this SoC vendor doesn't want to merge their code upstream, fine, we
(kernel community) don't really care, and it's obvious the company
doesn't care, so what really is the issue here?

Eventually, the SoC will realize that they do need to get their code
merged, and we will still be here, as we aren't going anywhere.  At that
point in time, we will be glad to review patches and code like we do
every day for all of the thousands of other companies we deal with on a
weekly basis.

I don't see the problem here, do you?

greg k-h
