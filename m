Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbaCFCjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 21:39:55 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:53417
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757614AbaCFCjx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 21:39:53 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz98dIc89bh1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh87h2a8h839h947hd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 6 Mar 2014 10:39:49 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@freescale.com>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3] ARM: dts: imx6qdl-sabresd.dtsi: Add red led
Message-ID: <20140306023946.GD11366@S2101-09.ap.freescale.net>
References: <20140305114223.GN8784@S2101-09.ap.freescale.net>
 <1394045919-1375-1-git-send-email-vincent.stehle@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1394045919-1375-1-git-send-email-vincent.stehle@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 07:58:39PM +0100, Vincent Stehlé wrote:
> Make the red gpio led available to the user.
> 
> This can be toggled with the sysfs for example, or used as a heartbeat or mmc
> activity light by changing the trigger.
> 
> Signed-off-by: Vincent Stehlé <vincent.stehle@freescale.com>

Applied, thanks.

