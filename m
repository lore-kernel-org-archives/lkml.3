Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab3GWAsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 20:48:50 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:43222 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab3GWAss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 20:48:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAELBVzCK3Dm-HtAn3iy0Nz-MeOJVvRO20KqE0WojWF1nFv_-1Q@mail.gmail.com>
References: <CAELBVzCK3Dm-HtAn3iy0Nz-MeOJVvRO20KqE0WojWF1nFv_-1Q@mail.gmail.com>
Date: Mon, 22 Jul 2013 21:48:47 -0300
Message-ID: <CAELBVzCUrJXWB1dO2mOwoX97x+RO2AeCNEazXzG4DrHXSk9JmQ@mail.gmail.com>
Subject: Re: [Panic - Bisected] f1a18a10566081abfce1649c2f3884b28fff7372 cases
 panic on boot
From: Kevin Winchester <kjwinchester@gmail.com>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, forgot to change gmail to plain text mode, so the mailing lists
rejected this.

On 22 July 2013 21:45, Kevin Winchester <kjwinchester@gmail.com> wrote:
> I have found that the new CPU Package temperature thermal driver introduced
> in this merge window causes my HP laptop to panic on boot.
>
> An image of the panic information can be found here:
>
> https://lh6.googleusercontent.com/-lA_vInpGkIs/Ue3FySjGOoI/AAAAAAAAAG0/fRmh0Qjcs9o/w1135-h851-no/Linux+Screenshots+-+1
>
> I bisected to find the offending commit, since the error was quite
> reproducible.
>
> # first bad commit: [f1a18a10566081abfce1649c2f3884b28fff7372] Thermal: CPU
> Package temperature thermal
>
> I'll next try:
>
> - disabling the driver in my config (I enabled it when asked since thermal
> control seems like a good thing)
> - Reverting the patch on top of v3.11-rc2
>
>
> What other info can I provide or steps can I take to help with this?
>
>
> Thanks,
> Kevin
>
