Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab3GURPg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 13:15:36 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:33489 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab3GURPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 13:15:32 -0400
MIME-Version: 1.0
In-Reply-To: <32735792.sAmhGYT8HA@vostro.rjw.lan>
References: <32735792.sAmhGYT8HA@vostro.rjw.lan>
Date: Sun, 21 Jul 2013 10:15:31 -0700
X-Google-Sender-Auth: gF8JXjP9We_68ik9UNs5SAfJcks
Message-ID: <CA+55aFw_XKDjPdrY9cwf99n4G_FN3Y3HbGT8HB=pRxLHgTDeJA@mail.gmail.com>
Subject: Re: [GIT PULL] ACPI video support fixes for v3.11
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 5:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> I'm sending a separate pull request for this as it may be somewhat
> controversial.

Ugh. That's an understatement, and I hate the timing.

That said, it looks like it should be easy to revert if it causes
problems, and I guess it won't become better from waiting until the
next merge window. And the problems are hopefully going to be pretty
easily pinpointed to this.. So I've pulled it.

              Linus
