Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab3DWS1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:27:22 -0400
Received: from sauhun.de ([89.238.76.85]:40820 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756508Ab3DWS1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:27:21 -0400
Date: Tue, 23 Apr 2013 20:27:07 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Josef Ahmad <josef.ahmad@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Ben Dooks <ben-linux@fluff.org>, Jean Delvare <khali@linux-fr.org>,
        Stefan Roese <sr@denx.de>, Axel Lin <axel.lin@gmail.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [PATCH] i2c-designware: fix RX FIFO overrun
Message-ID: <20130423182707.GA3649@the-dreams.de>
References: <alpine.DEB.2.02.1304191859570.17829@localhost>
 <20130422071943.GK1283@intel.com>
 <53398.163.33.213.79.1366630241.squirrel@linux.intel.com>
 <20130422122808.GO1283@intel.com>
 <alpine.DEB.2.02.1304221508050.31571@localhost>
 <20130423163543.GB3228@the-dreams.de>
 <51465.163.33.213.85.1366739082.squirrel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51465.163.33.213.85.1366739082.squirrel@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > This driver had a major cleanup meanwhile. Could you rebase your patch
> > on top of my for-next branch? I guess this version should make it into
> > stable?
> >
> 
> This patch applies just fine on top of your i2c-embedded/for-next branch.

i2c-embedded? Ah, this one is outdated. Please check
git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-next.

Thanks,

   Wolfram
