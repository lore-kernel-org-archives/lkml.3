Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbaAFJHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:07:14 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:41926 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbaAFJHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:07:11 -0500
Message-ID: <1388999220.5891.3.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 4/11]  use ether_addr_equal_64bits
From: Johannes Berg <johannes@sipsolutions.net>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Joe Perches <joe@perches.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        kernel-janitors@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 10:07:00 +0100
In-Reply-To: <alpine.DEB.2.10.1401061001340.2079@hadrien>
References: <1388427307-8691-1-git-send-email-Julia.Lawall@lip6.fr>
	  <1388427307-8691-5-git-send-email-Julia.Lawall@lip6.fr>
	  <1388429761.4410.1.camel@jlt4.sipsolutions.net>
	  <alpine.DEB.2.02.1312302057420.2209@localhost6.localdomain6>
	  <1388438724.4573.2.camel@jlt4.sipsolutions.net>
	  <20131230215701.GA4938@khazad-dum.debian.net>
	  <1388445188.18164.0.camel@jlt4.sipsolutions.net>
	  <1388445422.26796.38.camel@joe-AO722>
	  <alpine.DEB.2.10.1401060947550.2079@hadrien>
	 <1388998750.5808.43.camel@joe-AO722>
	 <alpine.DEB.2.10.1401061001340.2079@hadrien>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 10:04 +0100, Julia Lawall wrote:

> OK, the question was expressed badly.  Is there any way to use the value
> to trigger an action at build time?  The only way I kow to trigger an
> action is with #error, but #error is processed by cpp, which doesn't know
> about the size of types.

That's exactly BUILD_BUG_ON(), I believe.

johannes


