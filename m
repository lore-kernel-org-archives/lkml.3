Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbaDXMwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:52:23 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:43152 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaDXMwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:52:21 -0400
MIME-Version: 1.0
In-Reply-To: <1398268276-9696-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1398268276-9696-1-git-send-email-antoine.tenart@free-electrons.com>
Date: Thu, 24 Apr 2014 14:52:20 +0200
Message-ID: <CACRpkdbT94HqVroM_0gSJJ8Q2+YaKXLwjFGMn+4SCa_PYiF19Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] ARM: berlin: add pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        zhiming Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 5:51 PM, Antoine Ténart
<antoine.tenart@free-electrons.com> wrote:

> This series adds support for the Marvell Berlin pin-controller, allowing
> to configure the pin muxing from the device tree.
>
> The Berlin pin-controller support is divided into 3 drivers, each
> driving one Berlin SoC. These drivers use a Berlin common part.
>
> This series applies on top of patches introducing the Marvell Berlin
> BG2Q you can find on Sebastian's berlin/for-next branch[1] and the patch
> allowing not to define the get_group_pins() function[2].
>
> Tested on the Berlin BG2Q.

So now I need some advice from the mvebu pinctrl maintainers
(Thomas, Sebastian etc):

- Is this a totally different pin controller so that drivers/pinctrl/mvebu
 can not be used?

- Really?

- OK can you help me review this thing?

- Should the base folder really be named "berlin" or is this going to
  be part of a bigger family of pin controllers so a more neutral name
  should be sought?

- Why do hardware engineers seek to reinvent wheels like pin
  controllers, GPIO and DMA engines all the time :-/

Yours,
Linus Walleij
