Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab3BEOjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:39:53 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:56465 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab3BEOjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:39:51 -0500
MIME-Version: 1.0
In-Reply-To: <1359720305-31933-2-git-send-email-blogic@openwrt.org>
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
	<1359720305-31933-2-git-send-email-blogic@openwrt.org>
Date: Tue, 5 Feb 2013 15:39:50 +0100
Message-ID: <CACRpkdamexpL2ZK3s7hbXFJvY0yYL9hMFONbXdBvrLbX6umK=A@mail.gmail.com>
Subject: Re: [PATCH 02/11] PINCTRL: lantiq: faulty bit inversion
From: Linus Walleij <linus.walleij@linaro.org>
To: John Crispin <blogic@openwrt.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 1:04 PM, John Crispin <blogic@openwrt.org> wrote:

> The logic of the OD bit was inverted when calling the pinconf get methode.
>
> Signed-off-by: John Crispin <blogic@openwrt.org>

Applied for fixes.

Thanks,
Linus Walleij
