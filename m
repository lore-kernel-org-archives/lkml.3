Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab3BEOxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:53:16 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:37418 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab3BEOxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:53:15 -0500
MIME-Version: 1.0
In-Reply-To: <1359720305-31933-7-git-send-email-blogic@openwrt.org>
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
	<1359720305-31933-7-git-send-email-blogic@openwrt.org>
Date: Tue, 5 Feb 2013 15:53:14 +0100
Message-ID: <CACRpkdav-KU0fqXtC79eku0QRF6T0S99u0aTPqzXCzuKSiny+Q@mail.gmail.com>
Subject: Re: [PATCH 07/11] PINCTRL: lantiq: one of the boot leds was defined incorrectly
From: Linus Walleij <linus.walleij@linaro.org>
To: John Crispin <blogic@openwrt.org>
Cc: linux-kernel@vger.kernel.org, Thomas Langer <thomas.langer@lantiq.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 1:05 PM, John Crispin <blogic@openwrt.org> wrote:

> On the Falcon SoC the bootleds are located on pins 9->14.
>
> Signed-off-by: Thomas Langer <thomas.langer@lantiq.com>
> Signed-off-by: John Crispin <blogic@openwrt.org>

Applied to devel, half-guessing this is not a serious regression.

Thanks,
Linus Walleij
