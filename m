Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaLXN3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 08:29:23 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51121 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaLXN3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 08:29:22 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, Brett Rudley <brudley@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Christophe Prigent <christophe.prigent@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: Do not crash if platform data is not populated
References: <1419346112-173303-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Wed, 24 Dec 2014 15:29:13 +0200
In-Reply-To: <1419346112-173303-1-git-send-email-mika.westerberg@linux.intel.com>
	(Mika Westerberg's message of "Tue, 23 Dec 2014 16:48:32 +0200")
Message-ID: <87mw6d9nx2.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mika Westerberg <mika.westerberg@linux.intel.com> writes:

> The driver looks for pdata->oob_irq_supported to find out if wowl can be
> supported. However, not all platforms populate pdata in which case we crash
> the kernel because of NULL pointer dereference.
>
> Fixes: 330b4e4be937 ("brcmfmac: Add wowl support for SDIO devices.")
> Reported-by: Christophe Prigent <christophe.prigent@intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Thanks, applied to wireless-drivers.git.

-- 
Kalle Valo
