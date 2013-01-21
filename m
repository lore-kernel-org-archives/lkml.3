Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3AUWpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:45:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51688 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab3AUWpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:45:39 -0500
Date: Mon, 21 Jan 2013 22:45:26 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Matt Sealey <matt@genesi-usa.com>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Ben Dooks <ben@simtec.co.uk>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
Message-ID: <20130121224526.GA23505@n2100.arm.linux.org.uk>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <201301212041.17951.arnd@arndb.de> <CAKGA1bn0-83d+BFRMGZDZ9MZ2nnx8e8wh-VS3XoG5UQJDC0npg@mail.gmail.com> <201301212230.07393.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301212230.07393.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 10:30:07PM +0000, Arnd Bergmann wrote:
> On Monday 21 January 2013, Matt Sealey wrote:
> > So is that a bug in that it is not available to ARM right now, a bug
> > in that it would be impossible for anyone on ARM to have ever tested
> > this code, or a bug in that it should NEVER be enabled for ARM for
> > some reason? John? Ingo? :)
> > 
> 
> I think it's a bug that it's not available. That does not look intentional.

What's a bug?  kernel/Kconfig.hz not being available?  No, it's
intentional.  (See my replies).
