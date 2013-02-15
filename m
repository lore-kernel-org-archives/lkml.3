Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab3BOTxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:53:54 -0500
Received: from sauhun.de ([89.238.76.85]:46872 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab3BOTxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:53:52 -0500
Date: Fri, 15 Feb 2013 20:53:48 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: mux: Remove unneeded platform_set_drvdata to NULL
 in remove
Message-ID: <20130215195347.GF4351@the-dreams.de>
References: <1360953682-25066-1-git-send-email-dianders@chromium.org>
 <20130215193736.GD4351@the-dreams.de>
 <CAD=FV=VTJN3bU1rpMyjDMvX1SYZJWoJCiNtHNe+nDrtwnXqTXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=VTJN3bU1rpMyjDMvX1SYZJWoJCiNtHNe+nDrtwnXqTXA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I'll re-send with I2C subsystem wide.  I probably won't attempt the
> whole kernel wide at this point, but would be very happy if someone
> else wanted to!  :)

Thanks. Please double check that setting NULL is really unneeded for the
non-platform-bus variants, too, or skip those if you are unsure. Please
also update the commit message to reference a stronger indication than
Stephen's "should not be necessary" ;) I do agree but for the commit
history, a better reference would be nice to educate readers.

Thanks,

   Wolfram

