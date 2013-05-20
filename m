Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab3ETLja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:39:30 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:35411 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab3ETLj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 07:39:29 -0400
MIME-Version: 1.0
In-Reply-To: <1368702961-4325-15-git-send-email-wsa@the-dreams.de>
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
	<1368702961-4325-15-git-send-email-wsa@the-dreams.de>
Date: Mon, 20 May 2013 13:39:28 +0200
Message-ID: <CACRpkda3NM0S_SSkm6aqyx=_i1GOFvJE6rCp29Wnmbo527itPQ@mail.gmail.com>
Subject: Re: [PATCH 14/33] drivers/pinctrl: don't check resource with devm_ioremap_resource
From: Linus Walleij <linus.walleij@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 1:15 PM, Wolfram Sang <wsa@the-dreams.de> wrote:

> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

I think I have already applied this?

Yours,
Linus Walleij
