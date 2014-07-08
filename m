Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaGHHZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:25:01 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:34741 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbaGHHY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:24:59 -0400
MIME-Version: 1.0
In-Reply-To: <1403789909-11252-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1403789909-11252-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Tue, 8 Jul 2014 09:24:59 +0200
Message-ID: <CACRpkdYh_o11Dk98g9fL2dYXRwSQ1rvCAoht3P0OEQYSCQoa0g@mail.gmail.com>
Subject: Re: [PATCH] gpio: gpio-vr41xx.c: Cleaning up values that are never used
From: Linus Walleij <linus.walleij@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 3:38 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:

> Remove variable that are never used
>
> This was found using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Hm that was easy enough to fix up properly by actually checking
the return value so I cooked another patch and put you as
Reported-by:, should be on the linux-gpio list.

Yours,
Linus Walleij
