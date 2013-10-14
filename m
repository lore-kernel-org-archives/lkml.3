Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab3JNBJF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 21:09:05 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:38644 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab3JNBJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 21:09:03 -0400
MIME-Version: 1.0
In-Reply-To: <1381264542-29396-2-git-send-email-wsa@the-dreams.de>
References: <1381264542-29396-1-git-send-email-wsa@the-dreams.de>
	<1381264542-29396-2-git-send-email-wsa@the-dreams.de>
Date: Mon, 14 Oct 2013 09:09:01 +0800
Message-ID: <CAMj5BkgLEe5ODb7KRhb8F0b7JjG6Tf8AdheokO2jyQLbSj7_mw@mail.gmail.com>
Subject: Re: [PATCH 1/9] i2c: i2c-designware-platdrv: replace
 platform_driver_probe to support deferred probing
From: zhangfei gao <zhangfei.gao@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 9, 2013 at 4:35 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> Subsystems like pinctrl and gpio rightfully make use of deferred probing at
> core level. Now, deferred drivers won't be retried if they don't have a .probe
> function specified in the driver struct. Fix this driver to have that, so the
> devices it supports won't get lost in a deferred probe.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> Cc: Zhangfei Gao <zhangfei.gao@linaro.org>

Acked-by: Zhangfei Gao <zhangfei.gao@linaro.org>

Thanks
