Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab3AUOug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:50:36 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:45439 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab3AUOue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:50:34 -0500
MIME-Version: 1.0
In-Reply-To: <1358509214-22407-1-git-send-email-fabio.baltieri@linaro.org>
References: <1358509214-22407-1-git-send-email-fabio.baltieri@linaro.org>
Date: Mon, 21 Jan 2013 15:50:34 +0100
Message-ID: <CACRpkdY-VChUeSsb8QppnVjj46EnQ=zv5cWnphoRvZveAvEeDg@mail.gmail.com>
Subject: Re: [PATCH 0/4] add ux500_wdt support
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 12:40 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> this set adds support for the ux500_wdt timer, implemented in the PRCMU
> unit of ST-Ericsson ux500 architecture.
>
> The first two patches add the necessary definitions and function export
> to the PRCMU driver currently in mainline, while the third an fourth
> patches add the actual watchdog driver and mfd_cell definition to make
> it probe when PRCMU is compiled in.
>
> As the patches touches files in both mfd and watchdog subsystems, what do
> you think is the best way to handle this set?

Acked-by: Linus Walleij <linus.walleij@linaro.org>

As the majority touch the MFD parts, can Wim ack this so Sam can
take it through the MFD tree?

Yours,
Linus Walleij
