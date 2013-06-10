Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab3FJOoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 10:44:18 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:50256 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3FJOoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 10:44:17 -0400
MIME-Version: 1.0
In-Reply-To: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
References: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
Date: Mon, 10 Jun 2013 16:35:56 +0200
Message-ID: <CACRpkdbygDNdsO=EzigPiBSnMmF-NVnF95HeBBavkry93i+ubQ@mail.gmail.com>
Subject: Re: [PATCH 00/10] regulator: ab8500-ext: Refactorings
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

> This patch aims to do the following:
>
>  - Separate the AB8500 External Regulator out from the AB8500 core
>    one for added control and reduced complexity
>  - Enable the AB8500 External Regulator for Device Tree
>  - Ensure EXT3 supplies the AUX regulators with voltage

The series:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Once the changes to MFD+Regulator are in I'm happy to take the
DT patches onto my ux500-devicetree branch. However I fear
I'll break something if I do it right now?

Yours,
Linus Walleij
