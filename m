Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab3CTHvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 03:51:37 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:50273 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810Ab3CTHvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 03:51:36 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dIda00h1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 20 Mar 2013 15:51:44 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Anson Huang <b20788@freescale.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <kernel@pengutronix.de>, <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/3] ARM: imx: enable anatop suspend/resume
Message-ID: <20130320075141.GE26941@S2101-09.ap.freescale.net>
References: <1363801180-8284-1-git-send-email-b20788@freescale.com>
 <20130320072930.GC26941@S2101-09.ap.freescale.net>
 <20130320204554.GA13929@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130320204554.GA13929@ubuntu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 04:45:54PM -0400, Anson Huang wrote:
> > > +void imx_anatop_pre_suspend(void)
> > 
> > static?
> This function will be called outside this file, so we can NOT use static here.

Sorry, I mistakenly put the comment there.

Shawn

