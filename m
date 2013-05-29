Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965449Ab3E2SUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:20:20 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:65485 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab3E2SUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:20:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130528211142.GD5065@oc6784271780.ibm.com>
References: <20130528211142.GD5065@oc6784271780.ibm.com>
Date: Wed, 29 May 2013 21:20:14 +0300
Message-ID: <CAHp75Vd1pE+Ds=CxE1DaP9PZPTRhxV50uVgFZdXpTfODN+yjLg@mail.gmail.com>
Subject: Re: [PATCH 4/8] rsxx: Corrected discard support version number.
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
Cc: axboe@kernel.dk,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 12:11 AM, Philip J. Kelleher
<pjk1939@linux.vnet.ibm.com> wrote:
> From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
>
> Changing the Discard support version number to the correct
> value.
>

> +++ linux-block/drivers/block/rsxx/rsxx_priv.h  2013-05-01 18:37:56.277183367 -0500
> @@ -273,7 +273,7 @@ enum rsxx_hw_fifo_flush {
>  };
>
>  enum rsxx_pci_revision {
> -       RSXX_DISCARD_SUPPORT = 2,
> +       RSXX_DISCARD_SUPPORT = 4,
>         RSXX_EEH_SUPPORT     = 3,

Shouldn't it be sorted from low to high?

--
With Best Regards,
Andy Shevchenko
