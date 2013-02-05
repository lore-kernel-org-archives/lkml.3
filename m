Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab3BEO6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:58:06 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61260 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab3BEO6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:58:02 -0500
MIME-Version: 1.0
In-Reply-To: <1359720305-31933-6-git-send-email-blogic@openwrt.org>
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
	<1359720305-31933-6-git-send-email-blogic@openwrt.org>
Date: Tue, 5 Feb 2013 15:58:01 +0100
Message-ID: <CACRpkdZWpCj8+wmPcpkzVf9WDy7ttRhrUBam0sEQBy92AoT3Fw@mail.gmail.com>
Subject: Re: [PATCH 06/11] PINCTRL: lantiq: only probe available pad controllers
From: Linus Walleij <linus.walleij@linaro.org>
To: John Crispin <blogic@openwrt.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 1:05 PM, John Crispin <blogic@openwrt.org> wrote:

> The template falcon.dtsi lists all 6 pad controllers that can be loaded. Only
> probe those that have status = "okay"; inside the dts file.
>
> Signed-off-by: John Crispin <blogic@openwrt.org>

Applied, thanks.

Yours,
Linus Walleij
