Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab3DCUwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 16:52:31 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:63925 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760979Ab3DCUwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 16:52:30 -0400
MIME-Version: 1.0
In-Reply-To: <1364560187-20495-1-git-send-email-fabio.baltieri@linaro.org>
References: <1364487669-24368-3-git-send-email-fabio.baltieri@linaro.org>
	<1364560187-20495-1-git-send-email-fabio.baltieri@linaro.org>
Date: Wed, 3 Apr 2013 22:52:30 +0200
Message-ID: <CACRpkdZY211JisP=GNp9CLY11X9UxZcTBNu7PZNZxZyM0sn5Vg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ARM: ux500: 8500: add ab8500-musb pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Patrice Chotard <patrice.chotard@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 1:29 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> From: Patrice Chotard <patrice.chotard@stericsson.com>
>
> Add necessary definitions to support ab8500-musb pinctrl default and
> sleep states.
>
> Signed-off-by: Patrice Chotard <patrice.chotard@stericsson.com>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
>
> Hi Linus,
>
> I'm sending a v2 on this one as I mis-replaced a device id (manually
> applied patch, sorry about that).
>
> Changes from v1:
> - fix typo in GPIO257_AE29 device name

Thanks, patch applied!

Yours,
Linus Walleij
