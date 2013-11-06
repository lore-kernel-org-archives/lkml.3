Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab3KFL6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:58:50 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:55970 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab3KFL6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:58:49 -0500
MIME-Version: 1.0
In-Reply-To: <1383732348-18576-2-git-send-email-lee.jones@linaro.org>
References: <1383732348-18576-1-git-send-email-lee.jones@linaro.org>
	<1383732348-18576-2-git-send-email-lee.jones@linaro.org>
Date: Wed, 6 Nov 2013 12:58:48 +0100
Message-ID: <CACRpkdbVamt97Mekz-XC5hPaW85jc-WQaUYTnJFWBW80nFEBpQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] ARM: ux500: Remove legacy ATAG SSP support
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 11:05 AM, Lee Jones <lee.jones@linaro.org> wrote:

> This hasn't been used since we converted the platform to DT only.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied to my ux500-devicetree branch (for v3.14...)

Yours,
Linus Walleij
