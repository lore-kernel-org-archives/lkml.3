Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708Ab3HGSOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:14:42 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:52268 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab3HGSOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:14:41 -0400
MIME-Version: 1.0
In-Reply-To: <1374602524-3398-15-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
	<1374602524-3398-15-git-send-email-wsa@the-dreams.de>
Date: Wed, 7 Aug 2013 20:14:40 +0200
Message-ID: <CACRpkdamOXROtqK9tmghAYcTFq1gmBYCNevk6CWU_7QjkE+SYQ@mail.gmail.com>
Subject: Re: [PATCH 14/27] drivers/pinctrl: don't check resource with devm_ioremap_resource
From: Linus Walleij <linus.walleij@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 8:01 PM, Wolfram Sang <wsa@the-dreams.de> wrote:

> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
> Please apply via the subsystem-tree.

Patch applied, but I had to drop the hunk to the imx driver, as that had
already arrived in the tree by some other patch.

Yours,
Linus Walleij
