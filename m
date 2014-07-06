Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbaGFIrG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 04:47:06 -0400
Received: from smtp-out-128.synserver.de ([212.40.185.128]:1210 "EHLO
	smtp-out-125.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751053AbaGFIrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 04:47:04 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 10131
Message-ID: <53B90CF6.1000103@metafoo.de>
Date: Sun, 06 Jul 2014 10:46:46 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Apelete Seketeli <apelete@seketeli.net>,
        Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-mips@linux-mips.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mips: jz4740: rename usb_nop_xceiv to usb_phy_generic
References: <1404588615-14722-1-git-send-email-apelete@seketeli.net> <1404588615-14722-2-git-send-email-apelete@seketeli.net>
In-Reply-To: <1404588615-14722-2-git-send-email-apelete@seketeli.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2014 09:30 PM, Apelete Seketeli wrote:
> Rename usb_nop_xceiv to usb_phy_generic in platform data to match the
> name change of the nop transceiver driver in commit 4525bee (usb: phy:
> rename usb_nop_xceiv to usb_phy_generic).
>
> The name change induced a kernel panic due to an unhandled kernel
> unaligned access while trying to dereference musb->xceiv->io_ops in
> musb_init_controller().
>
> Signed-off-by: Apelete Seketeli <apelete@seketeli.net>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Ralf, the commit that caused this regression is in v3.16-rc1, can you queue 
this fix for v3.16-rcX?

Thanks,
- Lars
