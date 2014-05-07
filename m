Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbaEGA24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 20:28:56 -0400
Received: from mail0.toppoint.de ([217.70.197.20]:41425 "EHLO
	mail0.toppoint.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbaEGA2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 20:28:54 -0400
X-Greylist: delayed 541 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 May 2014 20:28:54 EDT
Date: Wed, 7 May 2014 00:18:30 +0000
From: Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>
To: David Miller <davem@davemloft.net>
Cc: nicolas.palix@imag.fr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com,
        ak@linux.intel.com, Julia.Lawall@lip6.fr, Gilles.Muller@lip6.fr
Subject: Re: [PATCH 23/24] net, diet: Add coccinelle script to convert
 drivers to ETHTOOL_OPS
Message-ID: <20140507001830.GA7875@kaos.lebenslange-mailadresse.de>
Mail-Followup-To: David Miller <davem@davemloft.net>, nicolas.palix@imag.fr,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	tom.zanussi@linux.intel.com, ak@linux.intel.com,
	Julia.Lawall@lip6.fr, Gilles.Muller@lip6.fr
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
 <1399328773-6531-24-git-send-email-andi@firstfloor.org>
 <CAAxaTiOYTEQgibnpDBXdhNpJUAVrLFwxz0roq8Bin1rNnnsxgg@mail.gmail.com>
 <20140506.110504.2135392385828482331.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506.110504.2135392385828482331.davem@davemloft.net>
X-message-flag: Get yourself a real email client. http://www.mutt.org/
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tue, May 06, 2014 at 11:05:04AM -0400 schrieb David Miller:
> SET_ETHTOOL_OPS only exists so that drivers could be compiled
> on "older" kernels.
> 
> But the usefulness of that is long gone, we've had netdev->ethtool_ops
> since way before we started using GIT.
> 
> I'd rather see a patch which removes it, to be honest.

Something like this?

https://www.lebenslange-mailadresse.de/lkml/remove-SET_ETHTOOL_OPS.patch

