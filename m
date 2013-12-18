Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab3LRQAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:00:53 -0500
Received: from seketeli.net ([91.121.166.71]:35300 "EHLO ms.seketeli.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab3LRQAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:00:51 -0500
Date: Wed, 18 Dec 2013 17:00:49 +0100
From: Apelete Seketeli <apelete@seketeli.net>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v2 1/3] mips: qi_lb60: add defconfig for Ben NanoNote
Message-ID: <20131218160049.GO4648@amegan>
References: <1387324561-21578-1-git-send-email-apelete@seketeli.net>
 <1387324561-21578-2-git-send-email-apelete@seketeli.net>
 <52B1B868.8010807@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B1B868.8010807@cogentembedded.com>
X-Operating-System: Debian GNU/Linux 7
X-URL: http://apelete.seketeli.fr
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 18-Dec-13, Sergei Shtylyov wrote:
> Hello.
> 
> On 18-12-2013 3:55, Apelete Seketeli wrote:
> 
> >Add defconfig for the Ben NanoNote handheld computer which is built
> >around QI_LB60 board and Ingenic JZ4740 MIPS SoC.
> 
> >Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
> >---
> >  arch/mips/configs/qi_lb60_defconfig |  188 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 188 insertions(+)
> >  create mode 100644 arch/mips/configs/qi_lb60_defconfig
> 
>    This should be sent to linux-mips@linux-mips.org and pushed thru
> the MIPS tree. No need to send this patch to linux-usb.

Understood, will send it to linux-mips@linux-mips.org.
Please ignore this patch for USB tree.

Cheers.
-- 
        Apelete
