Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab3FYTjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:39:48 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53020 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3FYTjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 15:39:46 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 25 Jun 2013 12:39:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
Subject: Re: [ 00/17] 3.0.84-stable review
Message-ID: <20130625193951.GF15184@roeck-us.net>
References: <20130625183915.443950649@linuxfoundation.org>
 <20130625192300.GA10427@roeck-us.net>
 <CAMuHMdVzqOLTVWHeGEFpkpDTt8hpor9zQpnn4bPDaNEGWnb=SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdVzqOLTVWHeGEFpkpDTt8hpor9zQpnn4bPDaNEGWnb=SQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 09:32:26PM +0200, Geert Uytterhoeven wrote:
> Hi Günther,
> 
> On Tue, Jun 25, 2013 at 9:23 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > Build m68k:defconfig passed
> > Build m68k:apollo_defconfig passed
> > Build m68k:m5272c3_defconfig failed
> > Build m68k:m5307c3_defconfig failed
> > Build m68k:m5249evb_defconfig failed
> > Build m68k:m5407c3_defconfig failed
> > Build m68k:mac_defconfig passed
> > Build m68k:multi_defconfig passed
> > Build m68k:sun3_defconfig passed
> > Build m68k:sun3x_defconfig passed
> > Build m68k:mvme16x_defconfig passed
> > Build m68k:hp300_defconfig passed
> 
> m68k:defconfig is an alias for m68k:multi_defconfig, so you can drop
> one of them.
> 
> Furthermore, m68k:multi_defconfig is the union of all m68k "classic MMU"
> defconfigs, except for sun3_defconfig (due to the incompatible MMU type).
> Hence dropping apollo_defconfig, mac_defconfig, sun3x_defconfig,
> mvme16x_defconfig, and hp300_defconfig would reduce your build coverage
> only marginally. Of course, if you have too many spare cycles ;-)
> 
Thanks, I'll do that. The complete build for three releases takes 15+ hours
with i7-3700k, so reducing that a bit doesn't hurt.

Would there be any useful builds to add ?

Thanks,
Guenter
