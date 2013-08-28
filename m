Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab3H1LRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:17:47 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:51653 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab3H1LRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:17:46 -0400
MIME-Version: 1.0
In-Reply-To: <1377239323.14131.1.camel@phoenix>
References: <1377239273.14131.0.camel@phoenix>
	<1377239323.14131.1.camel@phoenix>
Date: Wed, 28 Aug 2013 13:17:45 +0200
Message-ID: <CACRpkdZObbff4YjHA=EKvMYVem64DEHJ4TtBSKszbZU0waPW8g@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: rockchip: Remove non-reachable break statement
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 8:28 AM, Axel Lin <axel.lin@ingics.com> wrote:

> The break statement after return is non-reachable, remove them.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Patch applied.

Yours,
Linus Walleij
