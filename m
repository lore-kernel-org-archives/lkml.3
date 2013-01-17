Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab3AQNj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:39:29 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:63067 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3AQNj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:39:28 -0500
Date: Thu, 17 Jan 2013 13:39:21 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH] ARM: ux500: Include the PRCMU's Secure Registers in
 DB8500's DT
Message-ID: <20130117133921.GQ20091@gmail.com>
References: <1357901029-9073-1-git-send-email-lee.jones@linaro.org>
 <CACRpkdZhRESXHNVFPzUx7H0ppZ+KSfPOJ2bPS+-CQyv6+8=oZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZhRESXHNVFPzUx7H0ppZ+KSfPOJ2bPS+-CQyv6+8=oZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2013, Linus Walleij wrote:

> On Fri, Jan 11, 2013 at 11:43 AM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Currently we only include the PRCMU's primary registers when
> > referencing the register count in the 'reg' property. This patch
> > expands that count to include the secure registers also.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Will you push this to ARM SoC or shall I queue it?

I'll take it.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
