Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab3DOKnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 06:43:47 -0400
Received: from mail-ia0-f179.google.com ([209.85.210.179]:44222 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab3DOKnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 06:43:45 -0400
MIME-Version: 1.0
In-Reply-To: <1365499016-8348-1-git-send-email-fabio.baltieri@linaro.org>
References: <1365499016-8348-1-git-send-email-fabio.baltieri@linaro.org>
Date: Mon, 15 Apr 2013 12:43:40 +0200
Message-ID: <CACRpkdb2NMdArJcp2niS4=-sbnZtj75itu5Rm5WA0BHMpO7amg@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: Fix intcore regulator name
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 11:16 AM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> Ux500 regulator name for V-INTCORE is misspelled as vinitcore instead of
> vintcore in some .dts file, causing the AB8500 regulator driver to not
> bind properly.  Fix this by replacing all occurrences with the right
> name.
>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

I've accumulated the patch in my tree but will not be sending to
ARM SoC for v3.10 as of now. Currently I have a huge conflict
between some 4-5 DT patches and ARM SoC and I will just wait
for -rc1 to happen before trying to clean out the mess.

Yours,
Linus Walleij
