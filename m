Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbaEMHRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:17:44 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:47107 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758706AbaEMHRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:17:42 -0400
MIME-Version: 1.0
In-Reply-To: <1398759556-13056-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1398759556-13056-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Tue, 13 May 2014 09:17:42 +0200
Message-ID: <CACRpkdZr1MP2CL-609iJnv=MRHDhK554Hui5U77_SSUf7ARUqg@mail.gmail.com>
Subject: Re: [PATCH v1 02/11] mmc: mmci: Add Qualcomm Id to amba id table
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

On Tue, Apr 29, 2014 at 10:19 AM,  <srinivas.kandagatla@linaro.org> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> This patch adds a fake Qualcomm ID 0x00051180 to the amba_ids, as Qualcomm
> SDCC controller is pl180, but amba id registers read 0x0's.
> The plan is to remove SDCC driver totally and use mmci as the main SD
> controller driver for Qualcomm SOCs.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
