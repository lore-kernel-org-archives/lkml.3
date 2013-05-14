Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab3ENI0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:26:04 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:52502 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632Ab3ENIZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:25:58 -0400
MIME-Version: 1.0
In-Reply-To: <1368019749-19455-5-git-send-email-lee.jones@linaro.org>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
	<1368019749-19455-5-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 May 2013 10:25:58 +0200
Message-ID: <CACRpkdakF3KSV9QM1E65X+Zipeu2=uA=wpMz2DMGZOCdM--Mdw@mail.gmail.com>
Subject: Re: [PATCH 4/9] mfd: db8500-prcmu: Supply the pdata_size attribute
 for db8500-thermal
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 3:29 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The MFD subsystem requires drivers to state the size of any platform
> data passed, or it will fail to assign it to the device. This will
> culminate in a NULL platform_data attribute and normally a failure to
> probe() or a kernel Oops.
>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
