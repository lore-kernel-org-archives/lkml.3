Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab3BKN7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 08:59:00 -0500
Received: from mail-ia0-f179.google.com ([209.85.210.179]:37540 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466Ab3BKN67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 08:58:59 -0500
MIME-Version: 1.0
In-Reply-To: <1355993839-12479-1-git-send-email-jean-nicolas.graux@stericsson.com>
References: <1355993839-12479-1-git-send-email-jean-nicolas.graux@stericsson.com>
Date: Mon, 11 Feb 2013 14:58:44 +0100
Message-ID: <CACRpkdZ4rK9t7qV_TFcZDDh9-1CL6LGrjuYapfRnPOa7YQWjEg@mail.gmail.com>
Subject: Re: [PATCH] mfd: support stmpe1801 18 bits enhanced port expander
From: Linus Walleij <linus.walleij@linaro.org>
To: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 9:57 AM, Jean-Nicolas Graux
<jean-nicolas.graux@stericsson.com> wrote:

> Provides support for 1801 variant of stmpe gpio port expanders.
> This chip has 18 gpios configurable as GPI, GPO, keypad matrix,
> special key or dedicated key function.
>
> Note that special/dedicated key function is not supported yet.
>
> Signed-off-by: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>

Sam, did you accidentally miss this patch?

It's been around for a while...

Yours,
Linus Walleij
