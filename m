Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935891Ab3DIMBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 08:01:13 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:62997 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763884Ab3DIMBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 08:01:12 -0400
MIME-Version: 1.0
In-Reply-To: <1365496521-16880-1-git-send-email-jean-nicolas.graux@stericsson.com>
References: <1365496521-16880-1-git-send-email-jean-nicolas.graux@stericsson.com>
Date: Tue, 9 Apr 2013 14:01:11 +0200
Message-ID: <CACRpkdbe3Ny3AdxEbD0QoWM8GgUbjY9oskqBbFRazePw23j-6Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: support stmpe1801 18 bits enhanced port expander
From: Linus Walleij <linus.walleij@linaro.org>
To: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 10:35 AM, Jean-Nicolas Graux
<jean-nicolas.graux@stericsson.com> wrote:

> Provides support for 1801 variant of stmpe gpio port expanders.
> This chip has 18 gpios configurable as GPI, GPO, keypad matrix,
> special key or dedicated key function.
>
> Note that special/dedicated key function is not supported yet.
>
> Signed-off-by: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

For all three patches.

Yours,
Linus Walleij
