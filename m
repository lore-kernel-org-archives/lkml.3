Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3COJdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:33:14 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:35045 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab3COJdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:33:13 -0400
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
Date: Fri, 15 Mar 2013 02:33:11 -0700
X-Google-Sender-Auth: y1d6FQarXQ4ezwb9hscqBbrNyQQ
Message-ID: <CANeU7Q=J8C1Gdd7kNbwQXD+5oka4XEmEo=bmKHbDU3UVcxtEHA@mail.gmail.com>
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

> Fun. The BIOS seems to ask for zero backlight. Maybe it means something
> else for Windows 8. White is the new black or something.

I did some experiment, I go to intel_backlight directory.
It show brightness is 4648, but actual_brightness is 0.
Then I do "echo 4648 > brightness", the screen actually
come back to light. X window function properly.

However, if I go to suspend and resume. It is black screen
again.

If I use the Fn+Brightness to adjust the brightness. It seems
the ACPI brightness is set to lowest. One press of "Fn+Brightness up"
will give me about 10% of the brightness. It does not feel like
white is the new black.

Chris
