Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748Ab3E0WLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 18:11:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:36018 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757107Ab3E0WLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 18:11:04 -0400
Message-ID: <1369691284.3557.34.camel@pasglop>
Subject: Re: [PATCH 1/2] ARM: kirkwood: proper retain MAC address workaround
 on DT ethernet
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: sebastian.hesselbarth@gmail.com, buytenh@wantstofly.org,
        jason@lakedaemon.net, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org
Date: Tue, 28 May 2013 07:48:04 +1000
In-Reply-To: <20130527.131857.945196320286011406.davem@davemloft.net>
References: <1369647565.3557.28.camel@pasglop> <51A33447.80305@gmail.com>
	 <1369655404.3557.33.camel@pasglop>
	 <20130527.131857.945196320286011406.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-27 at 13:18 -0700, David Miller wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Mon, 27 May 2013 21:50:04 +1000
> 
> > It would be handy to be able to just do something like
> > 
> >       of_set_property(node, name, ptr, len);
> > 
> > However, that wouldn't help much with the allocation/leak problem,
> > though at least it would be easier to use. It could also *try* to re-use
> > the current allocation if the new content is of smaller or equal size.
> 
> And this is so much better of an interface because it allows the
> OF implementation to decide how to deal with memory allocation
> and freeing.

Absolutely, I'm not arguing that point.

Cheers,
Ben.


