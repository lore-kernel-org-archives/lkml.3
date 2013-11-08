Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab3KHLbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 06:31:32 -0500
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:23379
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752648Ab3KHLba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 06:31:30 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz98dI154dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h1155h)
Date: Fri, 8 Nov 2013 19:29:20 +0800
From: Nicolin Chen <b42378@freescale.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <s.hauer@pengutronix.de>, <timur@tabi.org>, <shawn.guo@linaro.org>,
        <broonie@kernel.org>
CC: <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <pawel.moll@arm.com>,
        <linux-doc@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <linux-kernel@vger.kernel.org>, <rob.herring@calxeda.com>,
        <dmaengine@vger.kernel.org>, <ijc+devicetree@hellion.org.uk>,
        <linuxppc-dev@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 0/4] Add dual-fifo mode support of i.MX ssi
Message-ID: <20131108112919.GA5159@MrMyself>
References: <cover.1383907685.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1383907685.git.b42378@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 06:49:32PM +0800, Nicolin Chen wrote:
>  * ! This series of patches has a direct dependency between them. When
>  * ! applying them, we need to apply to one single branch. Otherwise,
>  * ! it would break currect branches.
> 
> Changelog
> v4:
>  * PATCH-3: Add period size constraint when using dual fifo mode
>  *
>  * Nothing changes for PATCH-1, PATCH-2 and PATCH-4


Sorry all, I mistook the version number. It should be version 5.

Please ignore this series version.

I'll resend v5 soon.

Nicolin Chen


