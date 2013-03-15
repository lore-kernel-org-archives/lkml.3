Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3COJGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:06:08 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:50466 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab3COJGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:06:06 -0400
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
Date: Fri, 15 Mar 2013 02:06:02 -0700
X-Google-Sender-Auth: COjCZCvXBk9CuOZFNJRQcHH34ZA
Message-ID: <CANeU7Qmk8JqCZzMh2Vdmydpm=9Bxi+x=HmRbXxX4CTz1H_PX=g@mail.gmail.com>
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

That did not work for me. Still have black screen on the tip of git.
I did that to the gurb2-efi.cfg
Here is my kernel cmdline:

$ cat /proc/cmdline
BOOT_IMAGE=/vmlinuz-3.9.0-rc2+
root=UUID=75d90f06-bcdc-40c0-a3a3-7edf9af38d41 ro rd.md=0 rd.lvm=0
rd.dm=0 rd.luks=0 vconsole.keymap=us LANG=en_US.UTF-8 drm.debug=0xe
"acpi_osi=!Windows\x202012"

Chris
