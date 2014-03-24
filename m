Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaCXLCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 07:02:39 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:57252 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbaCXLCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 07:02:37 -0400
MIME-Version: 1.0
In-Reply-To: <53301023.8080301@monstr.eu>
References: <1395083192-3224-1-git-send-email-sthokal@xilinx.com>
	<1395083192-3224-3-git-send-email-sthokal@xilinx.com>
	<CABb+yY1z1Rr-EyJaeHQDb+thmKZVk5V93avokx6Z_EEuQFHyrw@mail.gmail.com>
	<CA+mB=1Lwq=Z3E+K7KTCgDKdmEQ8s5DMsAQVLVijdNPknNzx+SA@mail.gmail.com>
	<CAJe_Zhdnz+bdFiAqPgdH5hOTfzYUsoMyd0qpoWkeDAqqU+itSQ@mail.gmail.com>
	<53301023.8080301@monstr.eu>
Date: Mon, 24 Mar 2014 16:32:36 +0530
Message-ID: <CABb+yY13sheOvhVUkYNAO7t16egnPdf5x_fSvNuXVsU4E=W1Eg@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] dma: Add Xilinx AXI Video Direct Memory Access
 Engine driver support
From: Jassi Brar <jassisinghbrar@gmail.com>
To: monstr@monstr.eu
Cc: Jassi Brar <jaswinder.singh@linaro.org>,
        Srikanth Thokala <sthokal@xilinx.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Levente Kurusa <levex@linux.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 4:29 PM, Michal Simek <monstr@monstr.eu> wrote:
> Hi Vinod,
>
> sorry for top posting.
>
> is there any chance to get this driver to the 3.15?
> Or have you already closed your dma repo for new drivers?
>
> The driver should be in pretty good shape after long review.
> From email below Srikanth got ACK from Jassi
> and there should be a small fix which Srikanth will send in v7
> which I hope will be the last version.
>
+1  Any change may come incrementally.

Btw, here's the ack
   Acked-by: Jassi Brar <jassisinghbrar@gmail.com>
