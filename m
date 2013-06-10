Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab3FJPSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 11:18:44 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:38503 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab3FJPSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 11:18:43 -0400
MIME-Version: 1.0
In-Reply-To: <1370621488-18130-3-git-send-email-lee.jones@linaro.org>
References: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
	<1370621488-18130-3-git-send-email-lee.jones@linaro.org>
Date: Mon, 10 Jun 2013 17:18:42 +0200
Message-ID: <CACRpkdZWc74MQqUdXbW=cEgzHbC7Og==Tq1iEbhQSeG891BWrA@mail.gmail.com>
Subject: Re: [PATCH 02/10] ARM: ux500: Provide a supply name for the AB8500
 AUX regulators to use
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 6:11 PM, Lee Jones <lee.jones@linaro.org> wrote:

> AB8500 AUX regulators are supplied by EXT3 on some boards. This supply
> phandle lookup will enable the regulator core to search for and locate
> the EXT3 supply at registration time.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied to my ux500-devicetree branch.

Yours,
Linus Walleij
