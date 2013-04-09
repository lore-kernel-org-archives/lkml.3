Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935656Ab3DITEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:04:47 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:43867 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759834Ab3DITEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:04:46 -0400
MIME-Version: 1.0
In-Reply-To: <1365532783-27425-7-git-send-email-lee.jones@linaro.org>
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org>
	<1365532783-27425-7-git-send-email-lee.jones@linaro.org>
Date: Tue, 9 Apr 2013 12:04:45 -0700
Message-ID: <CAHLZz133b6kydVwh0_Cn2yg-Q_MeUF+Z-7+CMY7TkB7KK2ssAQ@mail.gmail.com>
Subject: Re: [PATCH 7/8] dmaengine: ste_dma40: Use the BIT macro to replace
 ugly '(1 << x)'s
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 11:39 AM, Lee Jones <lee.jones@linaro.org> wrote:
>
> The aim is to make the code that little more readable.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---

>
>  #define MAX(a, b) (((a) < (b)) ? (b) : (a))

Not part of your patch, but probably a good idea to switch to the
generic MAX macro, this
one is evaluating its args twice.

Cheers,

Harvey
