Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbaJ2Jlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:41:47 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:34480 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbaJ2Jlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:41:45 -0400
MIME-Version: 1.0
In-Reply-To: <1414153014-152246-3-git-send-email-mika.westerberg@linux.intel.com>
References: <1414153014-152246-1-git-send-email-mika.westerberg@linux.intel.com>
	<1414153014-152246-3-git-send-email-mika.westerberg@linux.intel.com>
Date: Wed, 29 Oct 2014 10:41:44 +0100
Message-ID: <CACRpkdaQVxR_-gg12FhduzoFS0ZBk1GomX9U9od40HSY=9DLoA@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: Move Intel Baytrail pinctrl driver under
 intel directory
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

On Fri, Oct 24, 2014 at 2:16 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> We are going to have more pinctrl drivers for Intel hardware so separate
> all our pin controller drivers to own directory.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Patch applied.

Yours,
Linus Walleij
