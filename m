Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab3CKKAL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 06:00:11 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:39575 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753Ab3CKKAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 06:00:07 -0400
Message-ID: <513DAB22.2060309@openwrt.org>
Date: Mon, 11 Mar 2013 11:00:02 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org, blogic@openwrt.org,
        xsecute@googlemail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: convert to devm_ioremap_resource()
References: <1362987753-6607-1-git-send-email-silviupopescu1990@gmail.com>
In-Reply-To: <1362987753-6607-1-git-send-email-silviupopescu1990@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013.03.11. 8:42 keltezéssel, Silviu-Mihai Popescu írta:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
> ---
>  arch/mips/pci/pci-ar724x.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)

Acked-by: Gabor Juhos <juhosg@openwrt.org>

Just a minor note, arch/mips/pci/pci-ar71xx.c should be fixed as well probably.
