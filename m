Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3JQJA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 05:00:27 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:50005 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab3JQJAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 05:00:24 -0400
MIME-Version: 1.0
In-Reply-To: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
Date: Thu, 17 Oct 2013 11:00:22 +0200
Message-ID: <CACRpkdatoVFOOYru1RWPZTA6Q+mjO9kL7NLf=W803n4rF4Dz8g@mail.gmail.com>
Subject: Re: [PATCH 00/28]: dmaengine: use DMA_COMPLETE for dma completion status
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 6:28 PM, Vinod Koul <vinod.koul@intel.com> wrote:

> As we recently discussed in [1], the DMA_SUCCESS is an misnomer. The dmaengine
> does not acknowledge that dma completed succesfully. It can only signal dma was
> completed by it. Hence we should use DMA_COMPLTE as status instead of
> DMA_SUCCESS
>
> [1]: http://www.spinics.net/lists/arm-kernel/msg278346.html

This make things more clear. The series:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
