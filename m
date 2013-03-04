Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab3CDHDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:03:14 -0500
Received: from mail-ia0-f179.google.com ([209.85.210.179]:63625 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3CDHDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:03:13 -0500
MIME-Version: 1.0
In-Reply-To: <1362045667-23891-2-git-send-email-fabio.baltieri@linaro.org>
References: <1362045667-23891-1-git-send-email-fabio.baltieri@linaro.org>
	<1362045667-23891-2-git-send-email-fabio.baltieri@linaro.org>
Date: Mon, 4 Mar 2013 08:03:12 +0100
Message-ID: <CACRpkdaW6S-ori9BWp0VJoKW=5CoqHvT6euM-MPf+3kFJBtdMg@mail.gmail.com>
Subject: Re: [PATCH RESEND 2/2] clocksource: dbx500-prcmu: comment cleanup
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: John Stultz <johnstul@us.ibm.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 11:01 AM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> Remove references to the deprecated DB5500 platform.
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

I've taken this and the other patch into the ux500 tree,
as per discussion with John changes to these drivers should
go through someone who can test it on the actual hardware.

Linus Walleij
