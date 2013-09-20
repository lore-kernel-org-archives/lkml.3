Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab3ITIgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 04:36:38 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:34779 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab3ITIgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 04:36:35 -0400
MIME-Version: 1.0
In-Reply-To: <1378294169-22661-2-git-send-email-acourbot@nvidia.com>
References: <1378294169-22661-1-git-send-email-acourbot@nvidia.com>
	<1378294169-22661-2-git-send-email-acourbot@nvidia.com>
Date: Fri, 20 Sep 2013 10:36:34 +0200
Message-ID: <CACRpkdZrjM0cQm8AXNDnaSh2Tp5BVcevDUObFg87cUTEmJxc1w@mail.gmail.com>
Subject: Re: [RFC 1/5] gpiolib: factorize gpiod_get/set functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 1:29 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> gpiod_get/set functions share common code between their regular and
> cansleep variants. The exporting of the gpiod interface will make
> the situation worse. This patch factorizes the common code to avoid code
> redundancy.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

I don't see why this patch should be RFC?

I just rebased and applied it, it's a clean and nice refactoring.

Yours,
Linus Walleij
