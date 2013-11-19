Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab3KSVDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 16:03:48 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:61954 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab3KSVDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 16:03:46 -0500
MIME-Version: 1.0
In-Reply-To: <1384859269-19801-3-git-send-email-lee.jones@linaro.org>
References: <1384859269-19801-1-git-send-email-lee.jones@linaro.org>
	<1384859269-19801-3-git-send-email-lee.jones@linaro.org>
Date: Tue, 19 Nov 2013 22:03:45 +0100
Message-ID: <CACRpkdbyEjxiytAj+UoCYkOXyMraTbTAkqpDbUw9Y_q6VqPsQQ@mail.gmail.com>
Subject: Re: [PATCH 02/10] dma: ste_dma40: Parse flags property for new 'high
 priority channel' request
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 12:07 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This is used for MSP (audio) devices which is about to be fully DT:ed.
>
> Acked-by: Vinod Koul <vinod.koul@intel.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied to the ux500-devicetree branch.

Yours,
Linus Walleij
