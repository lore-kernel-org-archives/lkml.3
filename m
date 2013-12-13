Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab3LMWOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:14:30 -0500
Received: from smtp2.macqel.be ([109.135.2.61]:62422 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab3LMWO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:14:29 -0500
Date: Fri, 13 Dec 2013 23:14:25 +0100
From: Philippe De Muyter <phdm@macq.eu>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, b29396@freescale.com, cjb@laptop.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: ARM,sdhci_esdhc_imx: INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock
	order detected
Message-ID: <20131213221425.GA32189@frolo.macqel>
References: <20131212144925.GA14995@frolo.macqel> <20131213133430.GW18380@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213133430.GW18380@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

On Fri, Dec 13, 2013 at 09:34:32PM +0800, Shawn Guo wrote:
> Hi Philippe,
> 
> On Thu, Dec 12, 2013 at 03:49:25PM +0100, Philippe De Muyter wrote:
> > Hello,
> > 
> > I have just booted 3.13-rc3 on my i.MX6DL board, done nothing but watch
> > it start, and I have got this!
> 
> There is a patch [1] from Fabio for this issue.
> 
> Shawn
> 
> [1] http://thread.gmane.org/gmane.linux.kernel.mmc/23786
> 
> > ======================================================
> > [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
...

Thanks.  That fixed the problem.  Will that go to 3.13 final ?

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
