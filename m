Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaG1NoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:44:10 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:11702 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaG1NoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:44:07 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19zxd60y8ar40gHsQ27YF+GCONym8HoalM=
X-DKIM: OpenDKIM Filter v2.0.1 titan A6C0C5B84A5
Date: Mon, 28 Jul 2014 09:43:47 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Benoit Masson <yahoo@perenite.com>
Cc: benoitm@perenite.com, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, gregory.clement@free-electrons.com,
        sebastian.hesselbarth@googlemail.com
Subject: Re: [PATCH 1/2] Adding Lenovo - Lenovo Group Ltd. to the
 vendor-prefixes list.
Message-ID: <20140728134347.GP23220@titan.lakedaemon.net>
References: <1406154923-13612-1-git-send-email-yahoo@perenite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406154923-13612-1-git-send-email-yahoo@perenite.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit,

On Wed, Jul 23, 2014 at 03:35:22PM -0700, Benoit Masson wrote:
> Lenovo Group Ltd. (stylized as lenovo) is a Chinese multinational
> computer technology company with headquarters in Beijing, China, and
> Morrisville, North Carolina, United States.
> 
> http://www.lenovo.com/
> Signed-off-by: Benoit Masson <yahoo@perenite.com>
> ---
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)

Applied to mvebu/dt with a few minor style changes to the commit log.

  - Added a blank line between the URL and the S-o-B.
  - Reflowed the paragraph to wrap at >80 chars
  - Changed subject to match other changes to vendor-prefixes.txt

The Subject line now reads:

  of: Add Lenovo Group Ltd. to the vendor-prefixes list.

You can view the patch here:

  http://git.infradead.org/linux-mvebu.git/commitdiff/74e025501bb834000b3c7eceab69383806520a36

Next, it'll go to arm-soc.  Then, Linus' tree.

thx,

Jason.
