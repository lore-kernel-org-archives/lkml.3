Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbbATMQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:16:10 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:62612 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbbATMQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:16:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFuJUxad0dJ9vK1DaDJPDLM+rc5b77=PgcJT5+Bv1=iWGxg@mail.gmail.com>
References: <1418890998-23811-1-git-send-email-heikki.krogerus@linux.intel.com>
	<CACRpkdY-yFKsYbCrMpnViMFoQEugyGQivaV0M+GDzLrbDO7i6Q@mail.gmail.com>
	<CAAVeFuJUxad0dJ9vK1DaDJPDLM+rc5b77=PgcJT5+Bv1=iWGxg@mail.gmail.com>
Date: Tue, 20 Jan 2015 13:16:06 +0100
Message-ID: <CACRpkdZzCX0O1wX=W5RbjLcqOF_R3HMTT1w59oFu=JfPauLNuw@mail.gmail.com>
Subject: Re: [RFC PATCH] gpio: support for GPIO forwarding
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Darren Hart <dvhart@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 6:59 AM, Alexandre Courbot <gnurou@gmail.com> wrote:

> I am not really fond of this idea since it adds complexity to the
> (already too complex) GPIO lookup, and only solves to a local level
> (GPIO) what is a more global problem (bad ACPI tables that can affect
> any subsystem).
(...)
> it
> seems more to-the-point to find a way to fix/patch the ACPI tables at
> runtime, if that is possible at all, to provide a more general
> solution to this issue.

This is my position as well, until proven that this cannot be done.
In device tree the same mechanism is called "device tree overlays"
and I just have some vague feeling that such stuff is patched around in
some Intel platforms already, but maybe that involves replacing
the whole DSDT from userspace, surely the mechanism can be
refined?

Yours,
Linus Walleij
