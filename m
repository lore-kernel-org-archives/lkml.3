Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbaAQEgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 23:36:07 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:34005 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751298AbaAQEgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 23:36:04 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19xpaP7YGjsX9vUoNzG8WJB/mBgJDi6TL8=
X-DKIM: OpenDKIM Filter v2.0.1 titan 7E1CA50C734
Date: Thu, 16 Jan 2014 23:35:53 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Grant Likely <grant.likely@secretlab.ca>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the devicetree tree with the
 arm-soc tree
Message-ID: <20140117043553.GL29184@titan.lakedaemon.net>
References: <20140117140853.6faf2c053617c5e66648526f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140117140853.6faf2c053617c5e66648526f@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Fri, Jan 17, 2014 at 02:08:53PM +1100, Stephen Rothwell wrote:
> Hi Grant,
> 
> Today's linux-next merge of the devicetree tree got a conflict in
> arch/arm/boot/dts/dove.dtsi between commits 40aad3c1a9b6 ("dt/bindings:
> Remove all references to device_type "ethernet-phy"") and b31b32119abe
> ("ARM: dove: sort DT nodes by address") from the devicetree tree and
> commit 351291754df3 ("dt/bindings: remove device_type "network"
> references") from the devicetree tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

Jason.
