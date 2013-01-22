Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3AVA0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 19:26:36 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:42197 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab3AVA0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 19:26:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAKGA1bk-K=D6EDBfJ7LggpTroj1sFC8VStctqGi=NacLEu95cA@mail.gmail.com>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com>
 <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org>
 <20130121211218.GX23505@n2100.arm.linux.org.uk> <CAKGA1bkZ4sN_eXAk1nUzvGE6cvvQ+b+jnTezTM863qFNL8NqWg@mail.gmail.com>
 <20130121224252.GY23505@n2100.arm.linux.org.uk> <CAKGA1b=AG_a=KCi6qoeoRoG+5bcYkn3gAVb4S2dbaFzu4ioJdQ@mail.gmail.com>
 <20130121234908.GD23505@n2100.arm.linux.org.uk> <CAKGA1bk-K=D6EDBfJ7LggpTroj1sFC8VStctqGi=NacLEu95cA@mail.gmail.com>
From: Matt Sealey <matt@genesi-usa.com>
Date: Mon, 21 Jan 2013 18:26:14 -0600
Message-ID: <CAKGA1bndiQkVSFh=Fpk8WjLe4L_EFyRa1mHyVUF9PFine-Wpcg@mail.gmail.com>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-samsung-soc@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 6:09 PM, Matt Sealey <matt@genesi-usa.com> wrote:

[LAKML: about lack of SCHED_HRTICK because we don't use
kernel/Kconfig.hz on ARM)]

> kind of leaves ARM in the doghouse.. who knows what weirdo scheduler
> reactions are related to it not being enabled. Maybe when it is, HZ
> *would* need to be allowed to be bumped when using this code path?

Or conversely maybe this is exactly why the Samsung maintainers
decided they need HZ=200, because SCHED_HRTICK isn't being enabled and
they're experiencing some multimedia lag because of it?

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
