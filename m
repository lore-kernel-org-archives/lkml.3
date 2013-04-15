Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3DOQks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:40:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34955 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab3DOQkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:40:47 -0400
Date: Mon, 15 Apr 2013 17:40:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
Cc: Mark Brown <broonie@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Nishanth Menon <nm@ti.com>, Tero Kristo <t-kristo@ti.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC v1] regulator: core: introduce regulator chain locking
 scheme
Message-ID: <20130415164018.GA14064@sirena.org.uk>
References: <1366031015-17073-1-git-send-email-grygorii.strashko@ti.com>
 <1366031015-17073-2-git-send-email-grygorii.strashko@ti.com>
 <20130415155040.GD15837@opensource.wolfsonmicro.com>
 <516C2905.8000200@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516C2905.8000200@ti.com>
X-Cookie: It was Penguin lust... at its ugliest.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 07:21:25PM +0300, Andrii Tseglytskyi wrote:
> On 04/15/2013 06:50 PM, Mark Brown wrote:

> >>In addition, such locking scheme allows to have access to the supplier
> >>regulator API from inside child's (consumer) regulator API.

> >I've still not seen any use case articulated for doing this...

> Use case is introduced in ABB series:

Sorry, I meant any sensible use case.
