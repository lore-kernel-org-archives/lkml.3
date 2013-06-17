Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab3FQFxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 01:53:22 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:50667 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab3FQFxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 01:53:20 -0400
MIME-Version: 1.0
In-Reply-To: <1370360926-3695-1-git-send-email-wsa@the-dreams.de>
References: <1370360926-3695-1-git-send-email-wsa@the-dreams.de>
Date: Mon, 17 Jun 2013 07:53:20 +0200
Message-ID: <CACRpkdYR4xAhekC3XagYEu2K+nEY22hEthB1ojHqPDsR=KKT_Q@mail.gmail.com>
Subject: Re: [PATCH] gpio: devres: make comments proper
From: Linus Walleij <linus.walleij@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 5:48 PM, Wolfram Sang <wsa@the-dreams.de> wrote:

> The free-function mentioned "interrupt" instead of "GPIO". While we are
> here, use "GPIO" (capital letters) consistently.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Patch applied.

Yours,
Linus Walleij
