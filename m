Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935071Ab3BTLKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:10:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63174 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935045Ab3BTLKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:10:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 0/4] dw_dmac: introduce generic DMA binding for DT
Date: Wed, 20 Feb 2013 11:10:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Dan Williams <djbw@fb.com>, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
References: <1360952512-971558-1-git-send-email-arnd@arndb.de> <201302200950.26182.arnd@arndb.de> <20130220095818.GI23302@intel.com>
In-Reply-To: <20130220095818.GI23302@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302201110.07485.arnd@arndb.de>
X-Provags-ID: V02:K0:rds6PRRiWA3eygRRQoau4tepoT3kT4mbOh4fBN+RIjH
 axcTr4xScPSOfr06aJxsFiGW8y5r5ei8wHisPlwhxdtliv0LPn
 p1biOt0F3mlOkQiGdVbSLvpP8nYGp+gnpc7PCcCCTtF2J9KA04
 9bChxgHysbgxPWRWVgygI1mmts23bcK2EBcoEst0l4q44itUk2
 XYJm4YPdTlXss+cVBloFKupAS87I4xwqUoaNDDx/DTuol/Hxl/
 2b9nnRq6rVahMgm1bhWg7ke6XINouR8r2YYIbKRozfbVoxkqgJ
 pFvKY3XgIVPp29TmU3Rru2Am3FpKCBDeF3/ADp8xmTC/AoJ1ln
 wI26zw/ZLSWBOtDEzhsQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2013, Vinod Koul wrote:
> On Wed, Feb 20, 2013 at 09:50:25AM +0000, Arnd Bergmann wrote:
> > On Wednesday 20 February 2013, Vinod Koul wrote:
> > > Since there is still churn, would it make sense if I just revert the SPEAr13xx
> > > patch (your first patch) and send a pull request to Linus.
> > > Since there are no users and not much testing has been done, I think we can push
> > > these to 3.10 via arm-soc/slave-dma tree.
> > > 
> > > Gives more testing and usage will go along as well.
> > > Since merge window is open, I would like my pull to go soonish and not churn the
> > > tree much.
> > 
> > Reverting the SPEAr13xx would definitely help, yes. The reason why I'd also like
> > to see the second patch get merged is so that we can do the SPEAr changes in 3.10
> > without having an interdependency between the trees. I tried very hard to
> > make the patch have a minimal impact on the non-DT code path to avoid regressions.
> Ok, i have applied your revert patch. Will send the PULL to linus by friday.

Ok, thanks.

> > Maybe you can send your tree now with just the revert applied, and then send the
> > other one separately next week along with any bug fixes that may have accumulated
> > by then?
> And then makes sense to send second PULL with fixes accumulated and the second
> patch, so that 3.10 is easier for all.  think we can compact() patch is second
> request as well

Yes, sounds good.

	Arnd
