Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab3BVS3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:29:30 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:51698 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758755Ab3BVS31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:29:27 -0500
MIME-Version: 1.0
In-Reply-To: <1361318824-22287-1-git-send-email-maxin.john@gmail.com>
References: <1361318824-22287-1-git-send-email-maxin.john@gmail.com>
Date: Fri, 22 Feb 2013 19:29:26 +0100
Message-ID: <CACRpkdZamOCWHWMcFYRqQDKJARZOCEP_eSNPNaxSgHfAn2wmEw@mail.gmail.com>
Subject: Re: [PATCH] dma: Remove erroneous __exit and __exit_p() references
From: Linus Walleij <linus.walleij@linaro.org>
To: maxin.john@gmail.com
Cc: gregkh@linuxfoundation.org, djbw@fb.com, nicolas.ferre@atmel.com,
        vinod.koul@intel.com, rmk+kernel@arm.linux.org.uk,
        jassisinghbrar@gmail.com, lars@metafoo.de, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        "Maxin B. John" <maxin.john@enea.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 1:07 AM,  <maxin.john@gmail.com> wrote:

> From: "Maxin B. John" <maxin.john@enea.com>
>
> Removing the annotation with __exit and referencing with __exit_p()
> present in dma driver module remove hooks.
>
> Part of the __devexit and __devexit_p() purge.
>
> Signed-off-by: Maxin B. John <maxin.john@enea.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
