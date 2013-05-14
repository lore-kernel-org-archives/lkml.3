Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab3ENI1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:27:33 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:49221 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065Ab3ENI1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:27:31 -0400
MIME-Version: 1.0
In-Reply-To: <1368019749-19455-6-git-send-email-lee.jones@linaro.org>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
	<1368019749-19455-6-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 May 2013 10:27:31 +0200
Message-ID: <CACRpkdY669Af-DK9jPkW==u9PtqnL=pipiN9Rx8hi=PHO5mtyg@mail.gmail.com>
Subject: Re: [PATCH 5/9] ARM: ux500: Fix incorrect DEBUG UART virtual addresses
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 3:29 PM, Lee Jones <lee.jones@linaro.org> wrote:

> A recent move to rid header files which were hindering multiplatform
> support forced address allocations out of the headers and into the
> files which were using them. We also lost some useful macros such as
> IO_ADDRESS(), so physical -> virtual addressing has been carried out
> manually in this case. Unfortunately the incorrect value was converted.
> This patch rectifies the error and ensures earlyprintk works again.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Thanks for fixing this!

And sorry for screwing it up :-(

Patch applied!

Yours,
Linus Walleij
