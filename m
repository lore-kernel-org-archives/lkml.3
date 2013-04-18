Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab3DRLII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:08:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58644 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab3DRLIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:08:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 25/32] ARM: ux500: Setup the DMA40 driver's DT node using the new DMA API
Date: Thu, 18 Apr 2013 13:08:02 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org> <1366279934-30761-26-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1366279934-30761-26-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181308.03130.arnd@arndb.de>
X-Provags-ID: V02:K0:17ldJBma8hdaUXBL5EFW8z/qc1Erpo+Uo6cHEXkFue1
 0540B/hNCuGNVyoK7NMU/BIYOATkn75DnL0A81F7jmPAZBa+rX
 8byIMRu1BiR28oAgmus9r9CAs4DBjwwWjYP4ZOQrdccu7HY2gM
 CFlAyDcvTjDCbf+L8qYH9YgWhWQLcfptfAOu8zfhzKXlQZlnaW
 ReToifnhurvXaH+8f9t+d6RBhngs9R7YKIOn1Lk3Fh6K9xu8sw
 QGsvnfOU12wfomdPG692GAhIFrg5GP0SMXO2t42jV019IPGSmf
 5O8dR+ED2P9lFCEgU5GCIhTzsveBbBREO+ZCMGSwwXbQBidAZE
 3weO1mCP1k15YLrvJ5hs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Lee Jones wrote:
> The new DMA is now available, so let's use it to setup ST-Ericsson's
> DMA40 driver when Device Tree is enabled.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
