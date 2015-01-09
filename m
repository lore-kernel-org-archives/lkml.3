Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbbAIJpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:45:08 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:48141 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194AbbAIJpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:45:05 -0500
MIME-Version: 1.0
In-Reply-To: <1417689170-41627-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1417689170-41627-1-git-send-email-mika.westerberg@linux.intel.com>
	<1417689170-41627-2-git-send-email-mika.westerberg@linux.intel.com>
Date: Fri, 9 Jan 2015 10:45:04 +0100
Message-ID: <CACRpkdZnZ_Oz5MsC2XxTwOL=FLY-dA5xNN_tOH5COeNEsLix6Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: cherryview: Save and restore pin configs
 over system sleep
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 11:32 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> Before resuming from system sleep BIOS restores its view of pin
> configuration. If we have configured some pins differently from that, for
> instance some driver requested a pin as a GPIO but it was not in GPIO mode
> originally, our view of the pin configuration will not match the hardware
> state anymore.
>
> This patch saves the pin configuration and interrupt mask registers on
> suspend and restores them on exit. This should make sure that the
> previously configured state is still in effect.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Patch applied for 3.20.

Yours,
Linus Walleij
