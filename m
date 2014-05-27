Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaE0NYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:24:30 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:45428 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaE0NY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:24:26 -0400
MIME-Version: 1.0
In-Reply-To: <1400893054-16126-1-git-send-email-sboyd@codeaurora.org>
References: <1400893054-16126-1-git-send-email-sboyd@codeaurora.org>
Date: Tue, 27 May 2014 15:24:25 +0200
Message-ID: <CACRpkdaZWCz4Nv7ya51fy9QjCBtEru50CjrX6ki1EF0OH-5sgg@mail.gmail.com>
Subject: Re: [PATCH] spi: Set cs-gpios to output direction
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Richard Genoud <richard.genoud@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 2:57 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> Also, is it better to convert this over to the gpiod interfaces?

Yes :-)

Yours,
Linus Walleij
