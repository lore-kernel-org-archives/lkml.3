Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab3EMFja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 01:39:30 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:28115 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750902Ab3EMFj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 01:39:28 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2dh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
Date: Mon, 13 May 2013 13:39:41 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Wolfram Sang'" <wsa@the-dreams.de>, <linux-kernel@vger.kernel.org>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        <linux-fbdev@vger.kernel.org>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [RFC 32/42] drivers/video: don't check resource with
 devm_ioremap_resource
Message-ID: <20130513053939.GA8542@S2101-09.ap.freescale.net>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
 <1368173847-5661-33-git-send-email-wsa@the-dreams.de>
 <002c01ce4e09$218612b0$64923810$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <002c01ce4e09$218612b0$64923810$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 11, 2013 at 02:33:56PM +0900, Jingoo Han wrote:
> On Friday, May 10, 2013 5:17 PM, Wolfram Sang wrote:
> > 
> > devm_ioremap_resource does sanity checks on the given resource. No need to
> > duplicate this in the driver.
> > 
> > Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> 
> CC'ed Tomi Valkeinen, Shawn Guo, Fabio Estevam

Acked-by: Shawn Guo <shawn.guo@linaro.org>

