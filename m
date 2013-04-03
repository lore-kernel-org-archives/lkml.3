Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763392Ab3DCUtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 16:49:50 -0400
Received: from mail-ia0-f169.google.com ([209.85.210.169]:53982 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763358Ab3DCUtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 16:49:49 -0400
MIME-Version: 1.0
In-Reply-To: <1364487669-24368-2-git-send-email-fabio.baltieri@linaro.org>
References: <1364487669-24368-1-git-send-email-fabio.baltieri@linaro.org>
	<1364487669-24368-2-git-send-email-fabio.baltieri@linaro.org>
Date: Wed, 3 Apr 2013 22:49:48 +0200
Message-ID: <CACRpkdbWho1x7DUmQuWXbiz1Gcx6gmR2U8Sh62hBQKF=8RpHVA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: ux500: remove redundant DB8500_PIN_SLEEP definition
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 5:21 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> DB8500_PIN_SLEEP was defined twice, drop one of the two.
>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

Patch applied.

Yours,
Linus Walleij
