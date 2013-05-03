Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761910Ab3ECCeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 22:34:00 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:39738 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757203Ab3ECCd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 22:33:59 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dIzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 3 May 2013 10:33:55 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
CC: Alexander Shiyan <shc_work@mail.ru>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH, RFC 20/22] media: coda: select GENERIC_ALLOCATOR
Message-ID: <20130503023353.GM3442@S2101-09.ap.freescale.net>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
 <1367507786-505303-21-git-send-email-arnd@arndb.de>
 <1367515255.447627800@f375.mail.ru>
 <201305022153.19518.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201305022153.19518.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 09:53:19PM +0200, Arnd Bergmann wrote:
> Unfortunately, linux-next as of today is still broken. Shawn, did I
> miss a pull request from you?

No, I haven't sent you a pull request for that.  I have queued it for
3.10-rc but am still waiting for a stable base (3.10-rc1 where
coda and genalloc changes should be merged together) to send it out.

Shawn

