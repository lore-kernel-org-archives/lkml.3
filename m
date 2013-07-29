Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3G2Te1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 15:34:27 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46841 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751410Ab3G2TeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 15:34:25 -0400
Message-ID: <1375126464.2075.46.camel@joe-AO722>
Subject: Re: [PATCH 2/3] include: Convert ethernet mac address declarations
 to use ETH_ALEN
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: netdev@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <samuel@sortiz.org>,
        "David S. Miller" <davem@davemloft.net>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Date: Mon, 29 Jul 2013 12:34:24 -0700
In-Reply-To: <2929374.frUlkyTFNL@vostro.rjw.lan>
References: <cover.1375075325.git.joe@perches.com>
	 <a769aba61c43967257854413f16d2b935cc54972.1375075325.git.joe@perches.com>
	 <2929374.frUlkyTFNL@vostro.rjw.lan>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-29 at 13:59 +0200, Rafael J. Wysocki wrote:
> On Sunday, July 28, 2013 10:29:04 PM Joe Perches wrote:
> > It's convenient to have ethernet mac addresses use
> > ETH_ALEN to be able to grep for them a bit easier and
> > also to ensure that the addresses are __aligned(2).
[]
> > diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
[]
> > @@ -44,6 +44,8 @@
[]
> > +#include <linux/if_ether.h>
> > +
[]
> > @@ -605,7 +607,7 @@ struct acpi_ibft_nic {
[]
> > -	u8 mac_address[6];
> > +	u8 mac_address[ETH_ALEN];

> Please don't touch this file.
> 
> It comes from a code base outside of the kernel and should be kept in sync with
> the upstream.

Which files in include/acpi have this characteristic?
Perhaps an include/acpi/README is appropriate.

