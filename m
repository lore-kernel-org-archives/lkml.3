Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaBXKEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:04:25 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:50538 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBXKEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:04:24 -0500
MIME-Version: 1.0
In-Reply-To: <1393165274-32492-2-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1393165274-32492-2-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 24 Feb 2014 11:04:23 +0100
Message-ID: <CACRpkdZAZL3_DEgEHmN+cCwbQaM3OU+xfDU35HiMuyc7zyky_Q@mail.gmail.com>
Subject: Re: [PATCH v4 01/16] pinctrl: mvebu: count unnamed controls and
 allocate name buffer
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

On Sun, Feb 23, 2014 at 3:20 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> pinctrl-mvebu allows SoCs to pass unnamed controls that will get an
> auto-generated name of "mpp<PIN#>". Currently, we are allocating name
> buffers on a per-control basis while looping over passed controls.
> This counts the total number of unnamed controls and allocates a
> global name buffer instead. The new buffer is then used while assigning
> controls to pinctrl groups later.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Tested-by: Andrew Lunn <andrew@lunn.ch>
> Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

This v4 version applied.

Yours,
Linus Walleij
