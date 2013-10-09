Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab3JIBZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 21:25:43 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:27916
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753378Ab3JIBZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 21:25:41 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 9 Oct 2013 09:25:56 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Olof Johansson <olof@lixom.net>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the imx-mxs tree
Message-ID: <20131009012554.GB8946@S2101-09.ap.freescale.net>
References: <1381239855-16314-1-git-send-email-treding@nvidia.com>
 <1381239855-16314-2-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1381239855-16314-2-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 03:44:12PM +0200, Thierry Reding wrote:
> Today's linux-next merge of the imx-mxs tree got conflicts in
> 
> 	arch/arm/mach-imx/mach-imx6q.c
> 
> caused by commits 4d9d18a (ARM: imx: remove custom .init_time hook),
> e709f38 (ARM: imx6: report soc info via soc device) and 3087d32 (ARM:
> imx6q: use common soc revision helpers).
> 
> I fixed it up (see below). Please verify that the resolution looks
> correct.

Thanks, Thierry.  The resolution is correct.

Shawn

