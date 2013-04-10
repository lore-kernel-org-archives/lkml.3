Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935072Ab3DJTtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 15:49:16 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:64881 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab3DJTtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 15:49:15 -0400
MIME-Version: 1.0
In-Reply-To: <1365337700.3916.1.camel@phoenix>
References: <1365337700.3916.1.camel@phoenix>
Date: Wed, 10 Apr 2013 21:49:14 +0200
Message-ID: <CACRpkdZZD05RGEODJZinHZCDAnN+LneTvChSGmECe1gKVrnHAw@mail.gmail.com>
Subject: Re: [PATCH] gpio: lpc32xx: Fix off-by-one valid range checking for bank
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Kevin Wells <kevin.wells@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 7, 2013 at 2:28 PM, Axel Lin <axel.lin@ingics.com> wrote:

> The valid bank should be 0 ... ARRAY_SIZE(lpc32xx_gpiochip) - 1.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Yep, that's right. Patch applied!

Yours,
Linus Walleij
