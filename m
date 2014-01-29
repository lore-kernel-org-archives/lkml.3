Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbaA2IxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 03:53:24 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:24618 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbaA2IxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 03:53:23 -0500
Message-ID: <52E8C17E.4050002@atmel.com>
Date: Wed, 29 Jan 2014 09:53:18 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mike Turquette <mturquette@linaro.org>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Boris BREZILLON" <b.brezillon@overkiz.com>
Subject: Re: linux-next: manual merge of the clk tree with Linus' tree
References: <20140129142551.6e6e27fc1a9440c762370af1@canb.auug.org.au>
In-Reply-To: <20140129142551.6e6e27fc1a9440c762370af1@canb.auug.org.au>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/01/2014 04:25, Stephen Rothwell :
> Hi Mike,
> 
> Today's linux-next merge of the clk tree got a conflict in
> drivers/clk/Makefile between commit 0ad6125b1579 ("clk: at91: add PMC
> base support") from Linus' tree and commit fd3fdaf09f26 ("clk: sort
> Makefile") from the clk tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Your fix is correct. Thanks Stephen.

Best regards,
-- 
Nicolas Ferre
