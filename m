Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964897AbaGDTyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 15:54:23 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:51034 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759624AbaGDTyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 15:54:21 -0400
MIME-Version: 1.0
In-Reply-To: <1404314924-23564-2-git-send-email-lee.jones@linaro.org>
References: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
	<1404314924-23564-2-git-send-email-lee.jones@linaro.org>
Date: Fri, 4 Jul 2014 21:54:21 +0200
Message-ID: <CACRpkdZXshshfv5928sVx25uPs5FRiWnca-JXUkn=+djO8Z-YQ@mail.gmail.com>
Subject: Re: [PATCH 01/12] mfd: ab8500-core: Remove pointless else in if statement
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 5:28 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Save a line of code (albeit, it's replaced by a blank line, but
> still), as the else is superfluous.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
