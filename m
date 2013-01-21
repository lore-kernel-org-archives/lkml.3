Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab3AUWFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:05:12 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:49625 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab3AUWFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:05:11 -0500
MIME-Version: 1.0
In-Reply-To: <1358544639-14761-2-git-send-email-maxime.ripard@free-electrons.com>
References: <1358544639-14761-1-git-send-email-maxime.ripard@free-electrons.com>
	<1358544639-14761-2-git-send-email-maxime.ripard@free-electrons.com>
Date: Mon, 21 Jan 2013 23:05:10 +0100
Message-ID: <CACRpkdbsv2ne6zgxtG4o0h6Vb3QKsprUttBUhSo4oJUVSzbURw@mail.gmail.com>
Subject: Re: [PATCH 1/7] pinctrl: pinconf-generic: add drive strength parameter
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Stefan Roese <sr@denx.de>, Alejandro Mery <amery@geeks.cl>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 10:30 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> Some pin configurations IP allows to set the current output to the pin.
> This patch adds such a parameter to the pinconf-generic mechanism.
>
> This parameter takes as argument the drive strength in mA.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

This is already applied...

Yours,
Linus Walleij
