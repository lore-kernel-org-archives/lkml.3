Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab3C0WDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 18:03:17 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:42447 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab3C0WDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 18:03:16 -0400
MIME-Version: 1.0
In-Reply-To: <1363869113-19610-1-git-send-email-fabio.baltieri@linaro.org>
References: <1363864186-11514-1-git-send-email-fabio.baltieri@linaro.org>
	<1363869113-19610-1-git-send-email-fabio.baltieri@linaro.org>
Date: Wed, 27 Mar 2013 23:03:15 +0100
Message-ID: <CACRpkda2G7E0T=NTde1RXA_98HLbu7iOL27_+L_vXUKFrcgJig@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: ux500: select WATCHDOG and MUSB for ux500
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 1:31 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> Enable ux500 specific USB and watchdog drivers by default on
> u8500_defconfig.
>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
>
> Hi again Linus,
>
> seems like this is being harder than I thought...  In v2 I had a
> duplicated CONFIG_AB8500_USB symbol that was giving a warning in make
> u8500_defconfig, this version fixes it.  Sorry about that, I'm trying to
> keep this patch minimal, but maybe it's time for a real update to the
> savedefconfig output.

OK this version is applied anyway ... I'll try to do a savedefconfig
update at some point.

Yours,
Linus Walleij
