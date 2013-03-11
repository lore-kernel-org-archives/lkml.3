Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3CKRO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:14:29 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:53067 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab3CKRO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:14:28 -0400
Message-ID: <513E10F3.8010306@openwrt.org>
Date: Mon, 11 Mar 2013 18:14:27 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org, blogic@openwrt.org,
        kaloz@openwrt.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: use newly introduced devm_ioremap_resource()
References: <1363015477-29685-1-git-send-email-silviupopescu1990@gmail.com>
In-Reply-To: <1363015477-29685-1-git-send-email-silviupopescu1990@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013.03.11. 16:24 keltezéssel, Silviu-Mihai Popescu írta:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>

Acked-by: Gabor Juhos <juhosg@openwrt.org>

