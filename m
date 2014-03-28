Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaC1M32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 08:29:28 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35898 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751051AbaC1M30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 08:29:26 -0400
Date: Fri, 28 Mar 2014 09:28:53 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [PATCH] axs_nand - add driver for NAND controller used on
 Synopsys AXS dev boards
Message-ID: <20140328122853.GA1636@arch.cereza>
References: <1394626349-16024-1-git-send-email-abrodkin@synopsys.com>
 <1395934023.3511.1.camel@abrodkin-8560l.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395934023.3511.1.camel@abrodkin-8560l.internal.synopsys.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 27, Alexey Brodkin wrote:
> On Wed, 2014-03-12 at 16:12 +0400, Alexey Brodkin wrote:
> > Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
> > 
> > Cc: Vineet Gupta <vgupta@synopsys.com>
> > ---
> >  Documentation/devicetree/bindings/mtd/axs-nand.txt |  17 +
> >  drivers/mtd/nand/Kconfig                           |   6 +
> >  drivers/mtd/nand/Makefile                          |   1 +
> >  drivers/mtd/nand/axs_nand.c                        | 412 +++++++++++++++++++++
> >  4 files changed, 436 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/mtd/axs-nand.txt
> >  create mode 100644 drivers/mtd/nand/axs_nand.c
> 
> Any chance to this patch reviewed, commented, accepted?
> 

FWIW, I plan to review this any time soon...
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
