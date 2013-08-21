Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab3HUNEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:04:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:36104 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab3HUNEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:04:23 -0400
Date: Wed, 21 Aug 2013 15:04:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Can you act as backup for timers/core and timers/urgent ?
In-Reply-To: <52138BD6.7070502@linaro.org>
Message-ID: <alpine.DEB.2.02.1308211502141.4089@ionos.tec.linutronix.de>
References: <52138BD6.7070502@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013, Daniel Lezcano wrote:
> Is it possible you act as a backup and you update timers/core which is
> in -rc1 to the latest -rc where I will rebase my tree on and resend a
> pull request with all the patches in (previous PR should be ignored) ?

I updated to linus latest and merged your tree. Rebasing is not what
we want. The patches were done against a certain state and tested
against that. So we want to preserve that and not some random untested
rebase conglomerate. Please check the conflict resolution once it hits
the public servers.

Thanks,

	tglx
