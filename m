Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3BEOjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:39:32 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:34403 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab3BEOjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:39:31 -0500
MIME-Version: 1.0
In-Reply-To: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
Date: Tue, 5 Feb 2013 15:39:28 +0100
Message-ID: <CACRpkdY6=LL3LQA6-iO5gcTukd9=vp3+SnVJ7fSSDBGQZ28YSw@mail.gmail.com>
Subject: Re: [PATCH 01/11] PINCTRL: lantiq: pinconf uses port instead of pin
From: Linus Walleij <linus.walleij@linaro.org>
To: John Crispin <blogic@openwrt.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 1:04 PM, John Crispin <blogic@openwrt.org> wrote:

> The XWAY pinctrl driver invalidly uses the port and not the pin number to work
> out the registeres and bits to be set for the opendrain and pullup/down
> resistors.
>
> Signed-off-by: John Crispin <blogic@openwrt.org>

Applied for fixes.

Thanks,
Linus Walleij
