Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbaIWPoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:44:46 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:59127 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397AbaIWPoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:44:44 -0400
MIME-Version: 1.0
In-Reply-To: <1410961621-15231-1-git-send-email-loic.poulain@intel.com>
References: <1410961621-15231-1-git-send-email-loic.poulain@intel.com>
Date: Tue, 23 Sep 2014 17:44:43 +0200
Message-ID: <CACRpkdYfMNVeK_X_oQFTnDwyZ_ZemUw3SBL0_JJvpToRXgdFSg@mail.gmail.com>
Subject: Re: [PATCHv2] pinctrl: baytrail: Clear DIRECT_IRQ bit
From: Linus Walleij <linus.walleij@linaro.org>
To: Loic Poulain <loic.poulain@intel.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 3:47 PM, Loic Poulain <loic.poulain@intel.com> wrote:

> Direct Irq En bit can be initialized to a bad value.
> This bit has to be cleared for io access mode.
>
> Signed-off-by: Loic Poulain <loic.poulain@intel.com>
> ---
>  v2: Apply over ff998356b644ebe723127bd9eec6040b59a4a4f6 + add Warning

I can't figure out if the maintainers like this patch or not.

If you want it applied, please ACK it explicitly.

Yours,
Linus Walleij
