Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbaCLNs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:48:56 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:53447 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbaCLNsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:48:54 -0400
MIME-Version: 1.0
In-Reply-To: <1394098276-11113-1-git-send-email-k.kozlowski@samsung.com>
References: <1394098276-11113-1-git-send-email-k.kozlowski@samsung.com>
Date: Wed, 12 Mar 2014 14:48:53 +0100
Message-ID: <CACRpkdaMVSVPmw8TiR=jgpkXeKw0inR9TzY7p9tDJQRrYU-HXw@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: max732x: Fix I2C dummy device resource leak on
 probe failure
From: Linus Walleij <linus.walleij@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 10:31 AM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:

> In max732x_probe() driver allocates dummy I2C device (if number of ports
> is greater than 8) however it is not unregistered if probe fails later.
> Fix the leak by unregistering dummy I2C device if it was allocated.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Patch applied.

Yours,
Linus Walleij
