Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab3LPKA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:00:57 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:50254 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab3LPKA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:00:56 -0500
Message-ID: <52AECF56.8020508@atmel.com>
Date: Mon, 16 Dec 2013 11:00:54 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Simon Horman <horms@verge.net.au>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: linux-next: manual merge of the renesas tree with the arm-soc
 tree
References: <20131216104738.6f845aabd0e3b609ed9ca170@canb.auug.org.au>
In-Reply-To: <20131216104738.6f845aabd0e3b609ed9ca170@canb.auug.org.au>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/12/2013 00:47, Stephen Rothwell :
> Hi Simon,
> 
> Today's linux-next merge of the renesas tree got a conflict in
> drivers/clk/Makefile between commit 0ad6125b1579 ("clk: at91: add PMC
> base support") from the arm-soc tree and commit 10cdfe9f327a ("clk:
> shmobile: Add R-Car Gen2 clocks support") from the renesas tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Fine for me.

Thanks. Bye,
-- 
Nicolas Ferre
