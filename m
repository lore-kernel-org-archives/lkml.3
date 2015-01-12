Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbbALU0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:26:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57668 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbbALU0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:26:53 -0500
Date: Mon, 12 Jan 2015 21:26:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andrew Lutomirski <luto@mit.edu>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Darren Hart <dvhart@infradead.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] platform-drivers-x86 for 3.19
Message-ID: <20150112202647.GB4425@pd.tnic>
References: <20141218175126.GA78864@vmdeb7>
 <20150111225802.GA12944@node.dhcp.inet.fi>
 <20150112183831.GA99900@vmdeb7>
 <CAObL_7FCiZJuTQNUfqjoxaRscB+_2fvwpnXDt3d8E+0dFm=i6A@mail.gmail.com>
 <20150112200331.GA23277@node.dhcp.inet.fi>
 <CAObL_7FwxW=oq9L+POVx_4S9HSZW2QM3bnTNW37rDsUA=-U3FA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAObL_7FwxW=oq9L+POVx_4S9HSZW2QM3bnTNW37rDsUA=-U3FA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 12:05:45PM -0800, Andrew Lutomirski wrote:
> What aspect of the old behavior is better than the new default behavior?

Btw, in my case, if I boot without the thinkpad_acpi.software_mute=0
thing, the small control light in the mute button doesn't light up to
show that mute is enabled. It still mutes properly in both cases though
so it is only a feedback thing which doesn't work anymore...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
