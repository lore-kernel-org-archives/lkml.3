Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab3LUPzS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 10:55:18 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34090 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab3LUPzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 10:55:14 -0500
Date: Sat, 21 Dec 2013 15:54:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Anson Huang <b20788@freescale.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Message-ID: <20131221155442.GP30815@sirena.org.uk>
References: <1387546930-32513-1-git-send-email-festevam@gmail.com>
 <20131221074900.GA6849@S2101-09.ap.freescale.net>
 <CAOMZO5Dg-NJ+rvFM=8Pb8ChcUMu803zqCX-1XMJJ6TBqarczfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5Dg-NJ+rvFM=8Pb8ChcUMu803zqCX-1XMJJ6TBqarczfw@mail.gmail.com>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 217.42.81.147
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: anatop-regulator: Remove unneeded check
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 12:25:50PM -0200, Fabio Estevam wrote:

> I see. Then we can do this instead, so that the successful probe and
> the error path are clearer:

Yes, that's going to cause fewer surprises.
