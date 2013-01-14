Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab3ANLXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 06:23:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:58507 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114Ab3ANLXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 06:23:19 -0500
Date: Mon, 14 Jan 2013 12:23:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        John Stultz <john.stultz@linaro.org>, arm@kernel.org
Subject: Re: [PATCH v2 0/3] Use helper clockevents_config_and_register()
In-Reply-To: <201301122114.07278.arnd@arndb.de>
Message-ID: <alpine.LFD.2.02.1301141222130.7475@ionos>
References: <1357991406-22778-1-git-send-email-shawn.guo@linaro.org> <201301122114.07278.arnd@arndb.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jan 2013, Arnd Bergmann wrote:
> On Saturday 12 January 2013, Shawn Guo wrote:
> > The clockevent core is able to figure out the best mult and shift,
> > calculate min_delta_ns and max_delta_ns, with the necessary info passed
> > into clockevents_config_and_register().  Use this handy helper to make
> > the drivers less error prone and save some LOC.
> > 
> > Changes since v1:
> >  - Add one patch to export clockevents_config_and_register for fixing
> >    the error [1] reported by Fengguang.
> >  - Add Acked-by and Tested-by tags given by people (Thanks!)
> > 
> > [1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/209152
> 
> Very nice series!
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Arnd, can you take the whole lot via the ARM tree? The export should
not cause any conflicts, and if it does Linus should be able to solve
it :)

Thanks,

	tglx

 
