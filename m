Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab3H2M6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 08:58:48 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:37258 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753106Ab3H2M6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 08:58:46 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(z37d4l551biz98dI1102Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 29 Aug 2013 20:58:55 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v2 08/16] ARM: mxs: remove custom .init_time hook
Message-ID: <20130829125851.GK18729@S2101-09.ap.freescale.net>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1377638890-371-9-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130829110849.GB18729@S2101-09.ap.freescale.net>
 <521F3151.1030704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <521F3151.1030704@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 01:32:33PM +0200, Sebastian Hesselbarth wrote:
> Ok, will take care of it. I assume you are fine with having an extra
> struct device_node pointer for the sake of readability instead of
> reusing the same pointer.

Yeah, something like np_digctl for digctl node.

Thanks for your work.

Shawn

