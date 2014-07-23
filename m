Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaGWNsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:48:04 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:25337 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751584AbaGWNsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:48:01 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19S0ORehRkQ2CAoCH7xtQT6i63i79rLxLs=
X-DKIM: OpenDKIM Filter v2.0.1 titan 6FE685B3EE0
Date: Wed, 23 Jul 2014 09:47:56 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: benoitm974 <yahoo@perenite.com>
Cc: benoitm@perenite.com, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Adding lenovo in vendor
Message-ID: <20140723134756.GG23220@titan.lakedaemon.net>
References: <1406117232-5962-1-git-send-email-yahoo@perenite.com>
 <1406117232-5962-2-git-send-email-yahoo@perenite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406117232-5962-2-git-send-email-yahoo@perenite.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit,

The same comments regard patch submission apply to this one as well.

On Wed, Jul 23, 2014 at 05:07:12AM -0700, benoitm974 wrote:

Please add a commit entry here describing Lenovo.  Keep it short and
sweet and maybe a link to their webpage.

> Signed-off-by: benoitm974 <yahoo@perenite.com>
> ---
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 46a311e..de81a87 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -72,6 +72,7 @@ keymile	Keymile GmbH
>  lacie	LaCie
>  lantiq	Lantiq Semiconductor
>  lg	LG Corporation
> +lenovo	LENOVO

is this their official, registered company name?

>  linux	Linux-specific binding
>  lsi	LSI Corp. (LSI Logic)
>  lltc	Linear Technology Corporation

thx,

Jason.
