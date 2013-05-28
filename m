Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184Ab3E1GvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 02:51:13 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:58179 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702Ab3E1GvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 02:51:12 -0400
MIME-Version: 1.0
In-Reply-To: <1369412476-14245-6-git-send-email-james.hogan@imgtec.com>
References: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com>
	<1369412476-14245-6-git-send-email-james.hogan@imgtec.com>
Date: Tue, 28 May 2013 08:51:12 +0200
Message-ID: <CACRpkdYvRHMaDYpO4WeP4TMeJnnhuRzs9_2zr8ObQZp1V47pHg@mail.gmail.com>
Subject: Re: [PATCH v2 5/9] pinconf-generic: add BIAS_BUS_HOLD pinconf
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 6:21 PM, James Hogan <james.hogan@imgtec.com> wrote:

> Add a new PIN_CONFIG_BIAS_BUS_HOLD pin configuration for a bus holder
> pin mode (also known as bus keeper, or repeater). This is a weak latch
> which drives the last value on a tristate bus. Another device on the bus
> can drive the bus high or low before going tristate to change the value
> driven by the pin.
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> ---
> Changes in v2:
>  - add BIAS_BUS_HOLD generic pinconf (patch 5)

Patch applied for v3.11.

Yours,
Linus Walleij
