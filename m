Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab3EHOAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:00:20 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:10362 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756715Ab3EHOAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:00:15 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h1151h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 8 May 2013 22:00:06 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        <linux-fbdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dts: cfa10036: Change the OLED display to
 SSD1306
Message-ID: <20130508140004.GC26072@S2101-09.ap.freescale.net>
References: <1366624555-5616-1-git-send-email-maxime.ripard@free-electrons.com>
 <1366624555-5616-3-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1366624555-5616-3-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 11:55:55AM +0200, Maxime Ripard wrote:
> The SSD1307 was used in an early prototype that will never get
> distributed. The final board now has a SSD1306 instead, that has its own
> power generation unit and thus doesn't need any PWM. The panel attached
> to it also changed.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Applied, thanks.

