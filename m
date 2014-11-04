Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaKDKXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:23:37 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:37869 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbaKDKXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:23:35 -0500
MIME-Version: 1.0
In-Reply-To: <1415012493-134561-3-git-send-email-mika.westerberg@linux.intel.com>
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com>
	<1415012493-134561-3-git-send-email-mika.westerberg@linux.intel.com>
Date: Tue, 4 Nov 2014 11:23:34 +0100
Message-ID: <CACRpkdZsyM-Wouyzq3uDBB9qXMy6UHDc3d+WVdtKEzYVZxXnFg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] pinctrl: Add Intel Cherryview/Braswell pin
 controller support
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 12:01 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> This driver supports the pin/GPIO controllers found in newer Intel SoCs
> like Cherryview and Braswell. The driver provides full GPIO support and
> minimal set of pin controlling funtionality.
>
> The driver is based on the original Cherryview GPIO driver authored by Ning
> Li and Alan Cox.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Simply a beautiful driver for a complex hardware (as pin controllers go)
so patch applied. Thanks a lot for you efforts of taking this effort
to adapt the embedded Intel to the world of pin control!

Yours,
Linus Walleij
