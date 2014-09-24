Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbaIXLk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:40:58 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:55915 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbaIXLk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:40:56 -0400
MIME-Version: 1.0
In-Reply-To: <1411512908-19237-1-git-send-email-behanw@converseincode.com>
References: <20140923212922.GG12270@beef>
	<1411512908-19237-1-git-send-email-behanw@converseincode.com>
Date: Wed, 24 Sep 2014 13:40:54 +0200
Message-ID: <CACRpkdZqtP+Q1NODQbT8ZfaViGvww+MwaPYPpN3_GdxZha44cQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] gpio, bcm-kona, LLVMLinux: Remove use of __initconst
From: Linus Walleij <linus.walleij@linaro.org>
To: behanw@converseincode.com
Cc: Christian Daudt <bcm@fixthebug.org>, Chris Ball <chris@printf.net>,
        Alexandre Courbot <gnurou@gmail.com>, Matt Porter <mporter@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Ray Jui <rjui@broadcom.com>, Mark Charlebois <charlebm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:55 AM,  <behanw@converseincode.com> wrote:

> From: Behan Webster <behanw@converseincode.com>
>
> The __initconst is in the wrong place, and when moved to the correct place
> it uncovers an error where the variable is used by non-init data structures.
>
> Instead merely make them const and put the const in the right spot.
>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Reviewed-by: Mark Charlebois <charlebm@gmail.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Matt Porter <mporter@linaro.org>

Patch applied.

Yours,
Linus Walleij
