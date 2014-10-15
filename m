Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaJOJBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:01:04 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:50701 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaJOJBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:01:01 -0400
MIME-Version: 1.0
In-Reply-To: <1411740891-3311-1-git-send-email-loic.poulain@intel.com>
References: <1411740891-3311-1-git-send-email-loic.poulain@intel.com>
Date: Wed, 15 Oct 2014 11:01:00 +0200
Message-ID: <CACRpkdb9HnnCM9F-JcMmUeADFWpRHzjvA-=0wLOs8U=Gs9YXUA@mail.gmail.com>
Subject: Re: [PATCHv3] pinctrl: baytrail: Clear DIRECT_IRQ bit
From: Linus Walleij <linus.walleij@linaro.org>
To: Loic Poulain <loic.poulain@intel.com>
Cc: "Westerberg, Mika" <mika.westerberg@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 4:14 PM, Loic Poulain <loic.poulain@intel.com> wrote:

> Direct irq en bit should be cleared for pads using io mode.
> If not, the io based irq will never be detected.
> However, this bit can sometimes be misconfigured (BIOS issue).
> Force clearing of this bit in io mode and trigger a WARN.
>
> Signed-off-by: Loic Poulain <loic.poulain@intel.com>
> ---
>  v2: Apply over ff998356b644ebe723127bd9eec6040b59a4a4f6 + add Warning
>  v3: Update commit message & warn message

Patch applied for fixes with Mika's ACK.. Sorry for the
delay.

Yours,
Linus Walleij
