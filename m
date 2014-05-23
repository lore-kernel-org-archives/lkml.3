Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaEWJDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:03:42 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:50560 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaEWJDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:03:39 -0400
MIME-Version: 1.0
In-Reply-To: <1400146621-30056-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1400146621-30056-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Fri, 23 May 2014 11:03:38 +0200
Message-ID: <CACRpkdYN3fg9Qd0oMYd3ghx4+8dqh8WwF5Aa-VjRDaxcOBZoKg@mail.gmail.com>
Subject: Re: [PATCH v2 06/14] mmc: mmci: Qcomm: Add 3 clock cycle delay after
 register write
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 11:37 AM,  <srinivas.kandagatla@linaro.org> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> Most of the Qcomm SD card controller registers must be updated to the MCLK
> domain so subsequent writes to registers will be ignored until 3 clock cycles
> have passed.
>
> This patch adds a 3 clock cycle delay required after writing to controller
> registers on Qualcomm SOCs. Without this delay all the register writes are not
> successful, resulting in not detecting cards. The write clock delay is
> activated by setting up mclk_delayed_writes variable in variant data.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

OK this is looking good.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
