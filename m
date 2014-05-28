Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbaE1IIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:08:25 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:63653 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbaE1IIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:08:22 -0400
MIME-Version: 1.0
In-Reply-To: <1400849589-7626-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1400849589-7626-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Wed, 28 May 2014 10:08:21 +0200
Message-ID: <CACRpkdb+pUn=9UkEVhK_2nL8C2wq_6qOuuRV52TRnj1hJiHvSg@mail.gmail.com>
Subject: Re: [PATCH v3 13/13] mmc: mmci: Add Qcom specific pio_read function.
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

On Fri, May 23, 2014 at 2:53 PM,  <srinivas.kandagatla@linaro.org> wrote:

> +       if (unlikely(bytes)) {
> +               unsigned char buf[4];
(...)

Please think twice about this.
http://lwn.net/Articles/70473/
http://lwn.net/Articles/420019/
http://lwn.net/Articles/182369/

Yours,
Linus Walleij
