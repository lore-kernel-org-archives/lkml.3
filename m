Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964873Ab3CSINs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 04:13:48 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:40354 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab3CSINo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 04:13:44 -0400
MIME-Version: 1.0
In-Reply-To: <87ip4tf7d7.fsf@intel.com>
References: <CANeU7QmbzX4Tx1Dtu6xOiYzr6h6_8tPQvVG32Wvkt=5wAwEEAg@mail.gmail.com>
	<20130219100849.72d2330b@jbarnes-desktop>
	<CANeU7QmJb+yUGu9mVgq=_pHhvpPu6ORrikm=E6PkuHpOz9OREA@mail.gmail.com>
	<20130219125217.6b6f55ff@jbarnes-desktop>
	<CANeU7QnQmKYXHA=aEuRGZDc7hVdY6037i=+s_n3FZNMN2njDsw@mail.gmail.com>
	<CAKMK7uG7TgiAn0ZQ=E_-QBPNAVhTSxpORkX3Z1mY=54mgTzM-g@mail.gmail.com>
	<CANeU7QnMzYuG6iiU3nLh4k0dGFMEDOyfUDQgxQSKj20_y-oL+Q@mail.gmail.com>
	<CAKMK7uGDpSKga9=2SrGQDxBGzY5B1cGJAchZvfKfQy1ivRONMg@mail.gmail.com>
	<CANeU7Q=K4Adu3yokT182ZaG3hW04bhDiXhyZgjngd7Nn+JD3aQ@mail.gmail.com>
	<CANeU7QmMYERbg9fCnyGuDcEdzwfErNT4B_7YbAD7w243hWdaQQ@mail.gmail.com>
	<CANeU7Q=hbU89zfcrP15ZAqMYaZPhQzM4f7i71txQDmESt0J36w@mail.gmail.com>
	<CANeU7Q=ge+z=uzpWdvXbfpZ0vaA0C0bnZcPBad5zKGyj1DmLAA@mail.gmail.com>
	<CAKMK7uGGN6ikKr4KvaJJ7iLPgK2KwE5RsgUn=WqTtvU-ryM5nQ@mail.gmail.com>
	<CAKMK7uEc5R8WrdDaQWQPG-0L+uEFc_5idkvwKm2vvLDeOGQ3tA@mail.gmail.com>
	<CANeU7Q=rbfDXULOsMqVkGCOny5aECwqNjEwyab37pPhHfVBa4w@mail.gmail.com>
	<CANeU7Q=_+qt5C3G2uKhQYq_hh9kOg5c8=uAvjQzRwvx_xOe2hA@mail.gmail.com>
	<87txoit6uf.fsf@intel.com>
	<CANeU7QmoW7EcmfPgzFqvo6UVjZnaYGp6UiB_4HP238v2SGhMRg@mail.gmail.com>
	<CANeU7QmJx=3m94ut0SYGEes4-C9khTMWbpee1u0rD4-esUpV=Q@mail.gmail.com>
	<87ip4tf7d7.fsf@intel.com>
Date: Tue, 19 Mar 2013 01:13:44 -0700
X-Google-Sender-Auth: jPmE1607emHj9XSkSbi9WqRpdqI
Message-ID: <CANeU7QnxVFZ6vXA2a9oZvxu5iEtFD6weANJiUp__RejFWaoX=A@mail.gmail.com>
Subject: Re: [Intel-gfx] i915 black screen introduced by ACPI changes
From: Chris Li <lkml@chrisli.org>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, len.brown@intel.com,
        feng.tang@intel.com, intel-gfx <intel-gfx@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, robert.moore@intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 12:29 AM, Jani Nikula
<jani.nikula@linux.intel.com> wrote:
> I've never used the acpi_osi= kernel parameter, but it looks like you
> could workaround this with acpi_osi="!Windows 2012". Please check that
> running the "bad" kernel.

I find out that I just can't set the acpi_osi="!Windows 2012" properly
in grub2.cfg.
Grub2 will second guess the quote and change it. So it end up Linux kernel will
 see "acpi_osi=!Windows\x202012" or some thing like that.

However, I just find out that if I set acpi_osi=Linux the black screen
will go away.
That is one usable work around on the stock fedora kernel.

Chris
