Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab3HUGaC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 02:30:02 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52132 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab3HUGaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 02:30:00 -0400
Date: Tue, 20 Aug 2013 23:29:59 -0700 (PDT)
Message-Id: <20130820.232959.1851816659900265372.davem@davemloft.net>
To: daniel@gimpelevich.san-francisco.ca.us
Cc: j.dumon@option.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix stack corruption on some architectures
From: David Miller <davem@davemloft.net>
In-Reply-To: <1376944647.5082.12.camel@chimera>
References: <1376944647.5082.12.camel@chimera>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 20 Aug 2013 23:30:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please submit this with a more appropriate subject line.

After '[PATCH] ' there should be a subsystem or driver name
prefix, followed up a semicolon.  Here it could be "hso: ",
so something like:

[PATCH] hso: Fix stack corruption on some architectures.
