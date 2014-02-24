Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbaBXKGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:06:14 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:37991 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaBXKGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:06:13 -0500
MIME-Version: 1.0
In-Reply-To: <1393165274-32492-4-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1393165274-32492-4-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 24 Feb 2014 11:06:12 +0100
Message-ID: <CACRpkdZ3yYAfQkXdZ28fuVdsb6pVD9wui7S__qzSUO6WJiWH3Q@mail.gmail.com>
Subject: Re: [PATCH v4 03/16] pinctrl: mvebu: identify generic controls by name
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 3:21 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> We treat unnamed controls as generic mvebu mpp register controls but
> we identify them by not being special controls. Flip the logic and
> use the name pointer as identification instead. While at it, add some
> comments explaining the not so obvious treatment.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Tested-by: Andrew Lunn <andrew@lunn.ch>
> Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Patch applied.

Yours,
Linus Walleij
