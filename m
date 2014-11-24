Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237AbaKXVJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:09:04 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:37828 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaKXVJB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:09:01 -0500
Content-Type: text/plain; charset=koi8-r
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v3 2/4] i2c: omap: implement workaround for handling invalid BB-bit values
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <20141124194759.GG2757@atomide.com>
Date: Tue, 25 Nov 2014 00:08:56 +0300
Cc: Alexander Kochetkov <al.kochet@gmail.com>,
        Kevin Hilman <khilman@kernel.org>, Felipe Balbi <balbi@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-omap <linux-omap@vger.kernel.org>, linux-i2c@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <465F63CE-4FAD-4CC8-94BB-D1E086E636B9@gmail.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com> <1416685634-5864-1-git-send-email-al.kochet@gmail.com> <1416685634-5864-3-git-send-email-al.kochet@gmail.com> <CAMAWPa8whctBR6fBFaSzPvm3qn+QK06CimRrxFxxH=0kNkF4UA@mail.gmail.com> <47A1A441-952C-4AC3-859C-5A8E405767E0@gmail.com> <20141124194759.GG2757@atomide.com>
To: Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


24 нояб. 2014 г., в 22:47, Tony Lindgren <tony@atomide.com> написал(а):

> I'd say by Tuesday as we have multiple automated test systems failing
> as soon as people update their trees. And when they are failing, we
> may miss other breakage happening in linux next.

Fix:
http://marc.info/?l=linux-i2c&m=141686120720069&w=2


