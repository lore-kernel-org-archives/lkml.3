Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbaIPTY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:24:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40102 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbaIPTY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:24:57 -0400
Date: Tue, 16 Sep 2014 21:24:46 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Joe Perches <joe@perches.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/8] arm: Convert pr_warning to pr_warn
Message-ID: <20140916192446.GK3755@pengutronix.de>
References: <cover.1410632834.git.joe@perches.com>
 <7995478e8c658478cd37dabb996f7269405251ac.1410632835.git.joe@perches.com>
 <20140915155656.GA29744@arm.com>
 <20140916160759.GJ12361@n2100.arm.linux.org.uk>
 <1410884281.16519.2.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410884281.16519.2.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Tue, Sep 16, 2014 at 09:18:01AM -0700, Joe Perches wrote:
> On Tue, 2014-09-16 at 17:07 +0100, Russell King - ARM Linux wrote:
> > any chance you could add a KernelVersion: tag somewhere in the
> > commit message and throw it at patches@arm.linux.org.uk so it doesn't
> > get lost?
> 
> There are no commit logs with a KernelVersion: tag
> in all of git history.
> 
> What do you think a KernelVersion: tag is and what
> would it be used for?
That's used in Russell's patch tracker, but the resulting commit doesn't
have the KernelVersion tag.

See http://www.arm.linux.org.uk/developer/patches/info.php for the
details.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
