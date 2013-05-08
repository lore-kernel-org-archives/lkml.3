Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab3EHOBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:01:13 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:13072 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755487Ab3EHOBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:01:11 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dIda00h1432Idc73hzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h1151h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 8 May 2013 22:01:02 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        <linux-fbdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] ARM: cfa10036: dt: Change i2c0 clock frequency
Message-ID: <20130508140101.GD26072@S2101-09.ap.freescale.net>
References: <1366624945-5708-1-git-send-email-maxime.ripard@free-electrons.com>
 <1366624945-5708-2-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1366624945-5708-2-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 12:02:22PM +0200, Maxime Ripard wrote:
> The OLED display can work faster. Change the i2c controller clock
> frequency to remove the tearing effect that can be seen on the display.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Applied, thanks.

