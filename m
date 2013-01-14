Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab3ANSQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:16:07 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:51737 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757065Ab3ANSQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:16:05 -0500
Date: Mon, 14 Jan 2013 10:16:05 -0800
From: Olof Johansson <olof@lixom.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <john.stultz@linaro.org>, arm@kernel.org
Subject: Re: [PATCH v2 0/3] Use helper clockevents_config_and_register()
Message-ID: <20130114181605.GB31901@quad.lixom.net>
References: <1357991406-22778-1-git-send-email-shawn.guo@linaro.org>
 <201301122114.07278.arnd@arndb.de>
 <alpine.LFD.2.02.1301141222130.7475@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1301141222130.7475@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 12:23:16PM +0100, Thomas Gleixner wrote:
> On Sat, 12 Jan 2013, Arnd Bergmann wrote:
> > On Saturday 12 January 2013, Shawn Guo wrote:
> > > The clockevent core is able to figure out the best mult and shift,
> > > calculate min_delta_ns and max_delta_ns, with the necessary info passed
> > > into clockevents_config_and_register().  Use this handy helper to make
> > > the drivers less error prone and save some LOC.
> > > 
> > > Changes since v1:
> > >  - Add one patch to export clockevents_config_and_register for fixing
> > >    the error [1] reported by Fengguang.
> > >  - Add Acked-by and Tested-by tags given by people (Thanks!)
> > > 
> > > [1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/209152
> > 
> > Very nice series!
> > 
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Arnd, can you take the whole lot via the ARM tree? The export should
> not cause any conflicts, and if it does Linus should be able to solve
> it :)

(with the presumed s/Arnd/Arnd or Olof/)

Great! I've applied these to a clockevent/cleanup topic branch in arm-soc,
together with the added acks, etc.


-Olof
