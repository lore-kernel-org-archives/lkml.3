Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaEPMn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:43:59 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:43405 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaEPMn6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:43:58 -0400
MIME-Version: 1.0
In-Reply-To: <1399267649-20218-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1399267649-20218-1-git-send-email-antoine.tenart@free-electrons.com>
Date: Fri, 16 May 2014 14:43:58 +0200
Message-ID: <CACRpkdYJU3HN2u=eFPUyM4eMmuT1Xw19zxjpb5nj9nXnar3_-A@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] ARM: berlin: add pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zhiming Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 7:27 AM, Antoine Ténart
<antoine.tenart@free-electrons.com> wrote:

> This series adds support for the Marvell Berlin pin-controller, allowing
> to configure the pin muxing from the device tree.

OK looking good!

I've applied patches 1,2,3,4 and 6 to the pin control tree.

Please carry patches 5 and 7 in the MVEBU tree or wherever
the core SoC is stashed up. It'd not be necessary to pull in the
pin control tree I think since you're just selecting symbols and
adding device trees. (The dependencies will magically fall in
during the merge window, so this is bisectable.)

Yours,
Linus Walleij
