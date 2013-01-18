Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab3ARTjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:39:21 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:59637 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab3ARTjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:39:20 -0500
MIME-Version: 1.0
In-Reply-To: <1357919129-1928-1-git-send-email-lee.jones@linaro.org>
References: <1357919129-1928-1-git-send-email-lee.jones@linaro.org>
Date: Fri, 18 Jan 2013 20:39:19 +0100
Message-ID: <CACRpkdb_E9tkaRTYMhgFhqBgwKZ2zXWNWh+0Pg7H_z3JNWLe4Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: ux500: Provide a link from AB8500 Pinctrl to the PRCMU
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 4:45 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The AB8500 Pinctrl driver uses PRCMU register addresses to
> control Pinctrl related functions. For this to happen, the
> Pinctrl driver needs the PRCMU base to work from. We can do
> that using standard Open Firmware (of_*) function calls, but
> first we need a mechanism to gain access to the PRCMU
> device node. We're going to use a Phandle in this case.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied to the pinctrl tree (so as to be adjacent to
the patch altering the code).

Yours,
Linus Walleij
