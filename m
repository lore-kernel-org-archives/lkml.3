Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab3KTNei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:34:38 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:49949 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab3KTNef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:34:35 -0500
MIME-Version: 1.0
In-Reply-To: <20131120002308.27342.34176.sendpatchset@w520>
References: <20131120002259.27342.35575.sendpatchset@w520>
	<20131120002308.27342.34176.sendpatchset@w520>
Date: Wed, 20 Nov 2013 14:34:34 +0100
Message-ID: <CACRpkda5=hmd7AXy-kFxBaMLktia41qwbYW-0hMATtao8uL3HA@mail.gmail.com>
Subject: Re: [PATCH 01/05 v2] gpio: rcar: Use lazy disable
From: Linus Walleij <linus.walleij@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 1:23 AM, Magnus Damm <magnus.damm@gmail.com> wrote:

> From: Magnus Damm <damm@opensource.se>
>
> Set the ->irq_enable() and ->irq_disable() methods to NULL
> to enable lazy disable of interrupts. This by itself provides
> some level of optimization, but is mainly enabled as ground
> work for future Suspend-to-RAM wake up support.
>
> Signed-off-by: Magnus Damm <damm@opensource.se>

Patch applied w/Laurent's ACK.

Yours,
Linus Walleij
