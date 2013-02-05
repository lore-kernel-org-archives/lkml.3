Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab3BEOmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:42:47 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:41645 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab3BEOmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:42:43 -0500
MIME-Version: 1.0
In-Reply-To: <1359720305-31933-3-git-send-email-blogic@openwrt.org>
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
	<1359720305-31933-3-git-send-email-blogic@openwrt.org>
Date: Tue, 5 Feb 2013 15:42:42 +0100
Message-ID: <CACRpkdaQ4rWw_p595SK+6hZRdgg2fNqS=D52Tbc4ixE7JZU6dg@mail.gmail.com>
Subject: Re: [PATCH 03/11] PINCTRL: lantiq: add pin_config_group_set support
From: Linus Walleij <linus.walleij@linaro.org>
To: John Crispin <blogic@openwrt.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 1:04 PM, John Crispin <blogic@openwrt.org> wrote:

> While converting all the boards supported by OpenWrt to OF I noticed that this
> feature is missing. Adding it makes the devicetrees more readable.
>
> Signed-off-by: John Crispin <blogic@openwrt.org>

Applied to my devel branch.

Thanks,
Linus Walleij
