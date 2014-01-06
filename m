Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbaAFVja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:39:30 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34894 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbaAFVj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:39:28 -0500
Date: Mon, 06 Jan 2014 16:39:26 -0500 (EST)
Message-Id: <20140106.163926.1801604023600319341.davem@davemloft.net>
To: dcbw@redhat.com
Cc: hns@goldelico.com, j.dumon@option.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        marek.belisko@gmail.com, e.verdonck@option.com
Subject: Re: [PATCH] hso: fix handling of modem port SERIAL_STATE
 notifications
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389044380.15419.4.camel@dcbw.local>
References: <1389024449.1866.3.camel@dcbw.local>
	<20140106.163036.1031013112322786.davem@davemloft.net>
	<1389044380.15419.4.camel@dcbw.local>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 06 Jan 2014 13:39:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dcbw@redhat.com>
Date: Mon, 06 Jan 2014 15:39:40 -0600

> If the driver ever gets to that callback for any !Modem port, something
> is horribly wrong, which the BUG_ON() was attempting to make explicit.
> The driver only enables that callback for the Modem port, so yeah, it's
> somewhat defensive.  I'm happy to send a fixup if you like?

You don't have to if you think the BUG_ON() is warranted.
