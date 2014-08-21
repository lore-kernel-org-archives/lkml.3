Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbaHUMmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:42:20 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:33553 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbaHUMmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:42:19 -0400
MIME-Version: 1.0
In-Reply-To: <1408446001-4998-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1408446001-4998-1-git-send-email-mathias.nyman@linux.intel.com>
Date: Thu, 21 Aug 2014 07:42:18 -0500
Message-ID: <CACRpkdbkwfeyRmHrLojdqdK-ygvSn=OkBrdJ+R-oye-DO3kxpQ@mail.gmail.com>
Subject: Re: [PATCHv2] gpio-lynxpoint: enable input sensing in resume
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 6:00 AM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:

> It appears that input sensing bit might be reset during
> suspend/resume. Set input sensing again for all requested gpios
> in resume
>
> Tested-by: Jerome Blin <jerome.blin@intel.com>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

This version applied with Mika's ACK.

Yours,
Linus Walleij
