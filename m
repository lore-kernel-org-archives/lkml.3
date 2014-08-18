Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbaHRNQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 09:16:27 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35377 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaHRNQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 09:16:26 -0400
Date: Mon, 18 Aug 2014 15:16:23 +0200
From: Pavel Machek <pavel@denx.de>
To: kernel list <linux-kernel@vger.kernel.org>, s.trumtrar@pengutronix.de,
        p.zabel@pengutronix.de, dinguyen@altera.com
Subject: altera reset controller in 3.16: failed with error -22
Message-ID: <20140818131623.GA21474@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm getting

socfpga-reset ffd05000.rstmgr: /soc/rstmgr@ffd05000 missing
#reset-cells property
socfpga-reset: probe of ffd05000.rstmgr failed with error -22

messages in 3.16... which is no wonder, since no socfpga-related dts
contains that property. Is there part of the patch that is missing
from 3.16?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
