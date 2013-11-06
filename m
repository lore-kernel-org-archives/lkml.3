Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab3KFLoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:44:14 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:47545 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588Ab3KFLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:44:11 -0500
MIME-Version: 1.0
In-Reply-To: <1383732985-18928-5-git-send-email-lee.jones@linaro.org>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
	<1383732985-18928-5-git-send-email-lee.jones@linaro.org>
Date: Wed, 6 Nov 2013 12:44:10 +0100
Message-ID: <CACRpkdaNy_h60FJYyTmxVFR8V87znP6KtzY48VhA7jHDTziAcw@mail.gmail.com>
Subject: Re: [PATCH 04/13] ARM: ux500: Add DMA config bindings for MSP devices
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 11:16 AM, Lee Jones <lee.jones@linaro.org> wrote:

> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Usually I would like to apply this separately to my ux500-dt branch.

While we should keep patches together for bisectability, the dts
files is something of an exception in my book since they will
be moved out of the kernel one day. Anyway, do as you please:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
