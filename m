Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046Ab3HGNvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:51:22 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:60179 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab3HGNvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:51:21 -0400
MIME-Version: 1.0
In-Reply-To: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
Date: Wed, 7 Aug 2013 15:51:21 +0200
Message-ID: <CACRpkdYAaCrRLjRwZVsq0Av0vc5Y4PODQchEwTCcrmYS47G3jw@mail.gmail.com>
Subject: Re: [PATCH 01/22] ARM: ux500: Remove '0x's from HREF v60+ DTS file
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 12:52 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Signed-off-by: Lee Jones <lee.jones@linaro.org>

None of these patches apply since I applied your other patch series
that rename all the files ... can you respin the ux500 "0x"-strip patches
on top of the rename set? My ux500-devicetree branch can be used
as a baseline.

Yours,
Linus Walleij
