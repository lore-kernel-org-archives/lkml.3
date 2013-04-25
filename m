Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab3DYI06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 04:26:58 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:36649 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab3DYI04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 04:26:56 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-8-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-8-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 10:26:56 +0200
Message-ID: <CACRpkdbCMjC22WbgE_-Co-hvT704n696Ox8t_6_d2aoxmZyybA@mail.gmail.com>
Subject: Re: [PATCH 07/32] ARM: ux500: Supply address location names for the
 DMA40 DMA controller
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 12:11 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The DMA40 controller uses two sets of base addresses. In order to have
> them automatically setup as resources by the Open Format framework we
> have to set names for them. The names have to be the same as the ones
> used to fetch them back out of the resource structure.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This is OK with Arnds suggested changed, but I want the patch
split off from this series and put into a device-tree-specific patch
series so I can apply this to a branch where I try to keep
all patches to the device tree files. (ux500-devicetree).

Yours,
Linus Walleij
