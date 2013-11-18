Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab3KRSz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:55:59 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:36300 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab3KRSzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:55:53 -0500
MIME-Version: 1.0
In-Reply-To: <20131118104343.GG13640@lee--X1>
References: <1384770649-8593-1-git-send-email-treding@nvidia.com>
	<1384770649-8593-2-git-send-email-treding@nvidia.com>
	<20131118104343.GG13640@lee--X1>
Date: Mon, 18 Nov 2013 10:55:52 -0800
X-Google-Sender-Auth: QwEdpkiWO1T38GZWjhd6M4GVqyk
Message-ID: <CAGAzgsrUedg7pGXpS6VaWkHeYjvcyio7byeEZ=88t3U1XzbsPQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] mfd: cros ec: spi: Increase EC transaction delay
From: "dbasehore ." <dbasehore@chromium.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, devicetree@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We haven't had any issues with this patch and we've had it in our tree
for a while.

I also stress tested the patch by repeatedly reading over the spi a lot.
