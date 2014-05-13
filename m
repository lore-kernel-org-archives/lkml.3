Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884AbaEMHUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:20:51 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:64460 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbaEMHUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:20:48 -0400
MIME-Version: 1.0
In-Reply-To: <1398759601-13178-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1398759601-13178-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Tue, 13 May 2014 09:20:48 +0200
Message-ID: <CACRpkdYB+6PeY6HMYe1t2VBPrv1sUtZkEimNPPHor9ziaUAztg@mail.gmail.com>
Subject: Re: [PATCH v1 05/11] mmc: mmci: use NSEC_PER_SEC macro
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        agross@quicinc.com,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 10:20 AM,  <srinivas.kandagatla@linaro.org> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> This patch replaces a constant used in calculating timeout with a proper
> macro. This is make code more readable.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

This can be merged out-of-order just as-is.

Yours,
Linus Walleij
