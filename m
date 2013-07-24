Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab3GXVFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 17:05:20 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:53576 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab3GXVFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 17:05:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130724210200.GY5939@phenom.ffwll.local>
References: <BLU0-SMTP125E791F01E26C3D60D7353A6680@phx.gbl>
	<17420057.BAULu67LQ3@vostro.rjw.lan>
	<CA+55aFzDgAcrzkkq06Qe9CBbBv6xKMYwPqtwv+ACryRSTRDOSQ@mail.gmail.com>
	<20130724210200.GY5939@phenom.ffwll.local>
Date: Wed, 24 Jul 2013 14:05:15 -0700
X-Google-Sender-Auth: _SQe0HDWsgVvUSVbb0yWKtr6i2s
Message-ID: <CA+55aFxvLox_iwPAg=iJx4F9M_FpMPY3ettFtAJOUk78d4+0pw@mail.gmail.com>
Subject: Re: [Intel-gfx] Linux 3.11-rc2 [backlight] [ASUS N56VZ]
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Aaron Lu <aaron.lu@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        =?UTF-8?B?KiBTQU3DjSAq?= <miaousami@hotmail.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 2:02 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>
> I think a i915 module option should be doable, otoh people seem to have a
> viable workaround by setting a different acpi os version already.

At least the original claim was that if you set a non-windows8 acpi os
version, you hit other bugs..

But yeah, if we just do a plain revert, that may be the only option
for the people for whom the current (to-be-reverted) patches made
things work.

            Linus
