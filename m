Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab3FQFsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 01:48:05 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:51935 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3FQFsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 01:48:03 -0400
MIME-Version: 1.0
In-Reply-To: <59b555e17f7cb055af93e555892bc43543c08ce3.1370262666.git.michal.simek@xilinx.com>
References: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
	<59b555e17f7cb055af93e555892bc43543c08ce3.1370262666.git.michal.simek@xilinx.com>
Date: Mon, 17 Jun 2013 07:48:02 +0200
Message-ID: <CACRpkdY-10tw1+DTWqeyGLYL2-3iaq7fK-OycJDK54+5uZjZuQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] GPIO: xilinx: Use BIT macro
From: Linus Walleij <linus.walleij@linaro.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 2:31 PM, Michal Simek <michal.simek@xilinx.com> wrote:

> Use BIT macro from linux/bitops.h.
>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> Changes in v2:
> - New patch in this series suggested by Linus Valleij

Patch applied.

Yours,
Linus Walleij
