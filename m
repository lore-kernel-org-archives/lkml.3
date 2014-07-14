Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbaGNQY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:24:26 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:38019 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbaGNQYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:24:17 -0400
MIME-Version: 1.0
In-Reply-To: <53C3D7C3.7090505@redhat.com>
References: <87pph8kse7.fsf@nemi.mork.no>
	<53C3D7C3.7090505@redhat.com>
Date: Mon, 14 Jul 2014 09:24:16 -0700
X-Google-Sender-Auth: joFq2ul3tKUTUcx18zXMugqRZ4k
Message-ID: <CA+55aFxYYKApOC+1TQkoxSzi-zTSB8OmkU=ypvNb_Gc2+K6Hmw@mail.gmail.com>
Subject: Re: [BISECTED 3.16-rc REGREGRESSION] backlight control stopped working
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 6:14 AM, Hans de Goede <hdegoede@redhat.com> wrote:
>
> This *not* a regression, it is an intended behavior change [..]

That counts as a regression.

If things used to work, and they don't work, it's a regression. If
it's intentional, that just makes it worse.

> Yes this may break existing configurations for some users, most likely
> users running some custom setup, who thus should be able to fix things
> by adding one more customization to there setup.

.. and apparently this whole paragraph is completely bogus. It *does*
break things, and for normal people. That's what the bug report is all
about. So don't waffle about it.

Bjørn, what's your setup? Is this perhaps solvable some other way?

> TL;DR: This change really is for the better and is here to stay.

Wrong. We don't break existing setups, and your attitude needs fixing.

Rafael, please get it reverted, or I will have to revert it. We have
*long* had a rule that we don't break things "in order to improve
things for others", and quite frankly, power management and ACPI in
particular was exactly *why* that rule was introduced, because the
whole "one step back, two steps forward" model does not work.

The problem needs to be solved some other way, and developers need to
f*cking stop with the "we can break peoples setups" mentality./

Hans, seriously. You have the wrong mental model. Fix it.

               Linus
