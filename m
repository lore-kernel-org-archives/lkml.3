Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaKKOYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:24:08 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:62670 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbaKKOYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:24:05 -0500
From: Tina Johnson <tinajohnson.1234@gmail.com>
X-Google-Original-From: Tina Johnson <tina@gmail.com>
Date: Tue, 11 Nov 2014 19:52:30 +0530 (IST)
X-X-Sender: tina@Miracleworker
To: David Miller <davem@davemloft.net>
cc: tinajohnson.1234@gmail.com, chas@cmf.nrl.navy.mil,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] drivers: atm: eni: Add pci_dma_mapping_error() call
In-Reply-To: <20141110.153228.2187951801277440496.davem@davemloft.net>
Message-ID: <alpine.DEB.2.02.1411111947230.6629@Miracleworker>
References: <1415463482-8013-1-git-send-email-tinajohnson.1234@gmail.com> <20141110.153228.2187951801277440496.davem@davemloft.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 10 Nov 2014, David Miller wrote:

> The 'trouble' label assumes that it is recovering and unwinding state
> when an error occurs after the DMA buffer is successfully mapped.
>
> It unconditionally does pci_unmap_single() if 'paddr' is non-zero
> which it might be in the error case depending upon how DMA errors
> are represented on a given platform.

Sorry for the trouble and thankyou for your very helpful comment. I
will send the revised patch.
