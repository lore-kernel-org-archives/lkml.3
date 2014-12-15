Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaLOLk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:40:26 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:42705 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaLOLkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:40:23 -0500
Date: Mon, 15 Dec 2014 11:39:54 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: NeilBrown <neilb@suse.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        NeilBrown <neil@brown.name>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] TTY/slave: add driver for w2sg0004 GPS
Message-ID: <20141215113954.21e2ea61@lxorguk.ukuu.org.uk>
In-Reply-To: <20141212160607.361d20db@notabene.brown>
References: <20141211214801.4127.93914.stgit@notabene.brown>
	<20141211215944.4127.57146.stgit@notabene.brown>
	<20141211231100.05782a30@lxorguk.ukuu.org.uk>
	<20141212160607.361d20db@notabene.brown>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Am I missing some w2sg004 specific bits here ?
> 
> There is particular behaviour that the device is both turned on and turned
> off by toggling a GPIO, and the only way to detect which state it is in is
> to watch the RX uart line (by reconfiguring it as a GPIO).

Ok so it is somewhat different to things like the Broadcom and the more
usual 'wait for idle, drop power' setup.


Alan
