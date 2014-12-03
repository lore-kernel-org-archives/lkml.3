Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbaLCOw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:52:26 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:54243 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaLCOwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:52:24 -0500
Content-Type: text/plain; charset=koi8-r
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [RFC 5/5] i2c: omap: add trace
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <20141203144934.GB16138@saruman>
Date: Wed, 3 Dec 2014 17:52:18 +0300
Cc: Kevin Hilman <khilman@kernel.org>, Tony Lindgren <tony@atomide.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <2E40A984-A6AA-4D17-AB1D-725004EF845F@gmail.com>
References: <1417617242-16869-1-git-send-email-al.kochet@gmail.com> <1417617242-16869-6-git-send-email-al.kochet@gmail.com> <20141203144934.GB16138@saruman>
To: balbi@ti.com
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


03 дек. 2014 г., в 17:49, Felipe Balbi <balbi@ti.com> написал(а):

> NAK, if you want to add traces, use, well, tracepoints :-) It makes no
> sense to hack stuff like this.

It's for testing only the problem reported not for upstream :)
The hack stuff like this is to allow for me to see what happens on the Tony's board.
I don't have omap2430 board.

Regards,
Alexander.

