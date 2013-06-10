Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab3FJPRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 11:17:40 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:53673 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab3FJPRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 11:17:39 -0400
MIME-Version: 1.0
In-Reply-To: <1370621488-18130-2-git-send-email-lee.jones@linaro.org>
References: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
	<1370621488-18130-2-git-send-email-lee.jones@linaro.org>
Date: Mon, 10 Jun 2013 17:17:38 +0200
Message-ID: <CACRpkdaXW5z69wA16qbr7TMNQaUH27VpVDFeH-0c-MEa7bJH7A@mail.gmail.com>
Subject: Re: [PATCH 01/10] ARM: ux500: Add Device Tree nodes for AB8500
 External regulators
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>, broonie@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 6:11 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The AB8500 has 3 external regulators which are used to control outside
> voltage sources. Some of the core AB8500 use these external regulators
> as a supply, so they must be obtainable via Device Tree.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied to my ux500-devicetree branch.

Yours,
Linus Walleij
