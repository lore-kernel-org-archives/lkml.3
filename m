Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3IRMYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:24:31 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:44281 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab3IRMY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:24:29 -0400
MIME-Version: 1.0
In-Reply-To: <1379506478-16625-3-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
	<1379506478-16625-3-git-send-email-lee.jones@linaro.org>
Date: Wed, 18 Sep 2013 14:24:28 +0200
Message-ID: <CACRpkdYEByC3vBegbziibY2R63S3zSWxW=OOj0=TaeGP4igROQ@mail.gmail.com>
Subject: Re: [PATCH 02/41] mfd: dbx500-prcmu: Move PRCMU numerical clock
 identifiers into DT include file
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 2:13 PM, Lee Jones <lee.jones@linaro.org> wrote:

> These are required to request DBx500 PRCMU clocks from Device Tree. The
> numbers used are taken directly from the Hardware Specification document.
> We're moving them from the DBx500 PRCMU include file into the DT include
> directory and referencing them from the former via a #include.
>
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
