Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab3DRVxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 17:53:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53109 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab3DRVxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 17:53:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 24/32 v3] dmaengine: ste_dma40: Supply full Device Tree parsing support
Date: Thu, 18 Apr 2013 23:53:44 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org> <20130418121253.GF27903@gmail.com> <20130418141752.GC3959@gmail.com>
In-Reply-To: <20130418141752.GC3959@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304182353.45092.arnd@arndb.de>
X-Provags-ID: V02:K0:YiUExy8aEHJR104wAsw1MJWOzh3rHvni2d2tZ3X+PIk
 bFwjd+aqfznHBOiYXWewo5hCcvyqBfu//O5k8lRI5v+KWEZrTw
 +PtHiQ1Om4DqbzuI5GKMrsHTC8NF5uw8EF2y5MipzJcST6DsFP
 +w5U1rZ13XLmV4JxNT3KexUKml8HZdDnVoDKFDNvB7KU74Kf6Y
 X1x+GL0+oCHG8ITK9Lklq1g10JeVntG57CvYqh9jpdTs2dviJM
 I3Vb1wInKvlFN36IJ0pHoM2IwnSC8q3RexindP3/k6CAJBIyeS
 z1BMUtMOcRr9Wk2TIEL0wL3+6qrWvQ5IVSj2KQe2kng/ICgyYH
 Mp0yKQqa4ipsTjCJsBGs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Lee Jones wrote:
> Using the new DMA DT bindings and API, we can register the DMA40 driver
> as Device Tree capable. Now, when a client attempts to allocate a
> channel using the DMA DT bindings via its own node, we are able to parse
> the request and allocate a channel in the correct manner.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
