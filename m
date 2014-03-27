Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbaC0Peq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 11:34:46 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:53456 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798AbaC0Peo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 11:34:44 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Mar 2014 11:34:44 EDT
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] axs_nand - add driver for NAND controller used on
 Synopsys AXS dev boards
Thread-Topic: [PATCH] axs_nand - add driver for NAND controller used on
 Synopsys AXS dev boards
Thread-Index: AQHPPexiEojKxmUszUq3rRMVB/UHe5r1FWWA
Date: Thu, 27 Mar 2014 15:27:04 +0000
Message-ID: <1395934023.3511.1.camel@abrodkin-8560l.internal.synopsys.com>
References: <1394626349-16024-1-git-send-email-abrodkin@synopsys.com>
In-Reply-To: <1394626349-16024-1-git-send-email-abrodkin@synopsys.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.121.8.115]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <1CFA6DDAFF3CB74B8CBFE99EE64EEDB8@internal.synopsys.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 16:12 +0400, Alexey Brodkin wrote:
> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
> 
> Cc: Vineet Gupta <vgupta@synopsys.com>
> ---
>  Documentation/devicetree/bindings/mtd/axs-nand.txt |  17 +
>  drivers/mtd/nand/Kconfig                           |   6 +
>  drivers/mtd/nand/Makefile                          |   1 +
>  drivers/mtd/nand/axs_nand.c                        | 412 +++++++++++++++++++++
>  4 files changed, 436 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mtd/axs-nand.txt
>  create mode 100644 drivers/mtd/nand/axs_nand.c

Any chance to this patch reviewed, commented, accepted?

Regards,
Alexey
