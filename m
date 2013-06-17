Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab3FQFjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 01:39:18 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:37166 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3FQFjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 01:39:17 -0400
MIME-Version: 1.0
In-Reply-To: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
References: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
Date: Mon, 17 Jun 2013 07:39:16 +0200
Message-ID: <CACRpkdZceLvsLUHd=T6d_B0L98MmLzPojxtJei4ypea-zthuCA@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] GPIO: xilinx: Simplify driver probe function
From: Linus Walleij <linus.walleij@linaro.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 2:31 PM, Michal Simek <michal.simek@xilinx.com> wrote:

> Simplification is done by using OF helper function
> which increase readability of code and remove
> (if (var) var = be32_to_cpup;) assignment.
>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> Changes in v2:
> - New patch in this series

Patch applied. Nice cleanup!

Yours,
Linus Walleij
