Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab3HPJfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 05:35:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42494 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab3HPJfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 05:35:13 -0400
MIME-Version: 1.0
In-Reply-To: <1374176130-21209-1-git-send-email-andi@etezian.org>
References: <1374176130-21209-1-git-send-email-andi@etezian.org>
Date: Fri, 16 Aug 2013 11:35:13 +0200
Message-ID: <CACRpkdYDLGaQJ+R0stejCLRY7sgdnEBqkBocfh0GqhD+WiLx3A@mail.gmail.com>
Subject: Re: [PATCH] u8500_defconfig: allow creation and mounting of devtmpfs
From: Linus Walleij <linus.walleij@linaro.org>
To: Andi Shyti <andi@etezian.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 9:35 PM, Andi Shyti <andi@etezian.org> wrote:

> This patch enables CONFIG_DETTMPFS and CONFIG_DEVTMPFS_MOUNT
> flags for u8500 based devices.
>
> In this way it's possible to create a tmpfs/ramfs already in the
> early stages of the boot, allowing programs like udev/mdev to
> populate the /dev directory.
>
> Signed-off-by: Andi Shyti <andi@etezian.org>

Patch applied.

Yours,
Linus Walleij
