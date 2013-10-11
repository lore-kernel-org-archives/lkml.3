Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab3JKOSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:18:08 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48938 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab3JKOSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:18:06 -0400
MIME-Version: 1.0
In-Reply-To: <1380916902-23791-3-git-send-email-david.a.cohen@linux.intel.com>
References: <1380916902-23791-1-git-send-email-david.a.cohen@linux.intel.com>
	<1380916902-23791-3-git-send-email-david.a.cohen@linux.intel.com>
Date: Fri, 11 Oct 2013 16:18:05 +0200
Message-ID: <CACRpkdZw29XE4z7iw2=JQbLMvWfpoWYm+-cgLB-oM8GzwK7xxg@mail.gmail.com>
Subject: Re: [PATCH 2/3] gpio: rename gpio-langwell to gpio-intel-mid
From: Linus Walleij <linus.walleij@linaro.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 4, 2013 at 10:01 PM, David Cohen
<david.a.cohen@linux.intel.com> wrote:

> gpio-langwell is a deprecated name. Despite the driver was made
> initially for Langwell, it supports now other Intel Mid SoC's.
>
> This patch does no change beside the file renaming with Kconfig/Makefile
> update.
>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>

Are you aware of the git format-patch -M switch?

Anyway, good idea, so patch applied.

Yours,
Linus Walleij
