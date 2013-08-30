Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab3H3LNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 07:13:36 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:46408 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab3H3LNf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 07:13:35 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Mischa Jonker <Mischa.Jonker@synopsys.com>
CC: "joe@perches.com" <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARC: Fix __udelay calculation
Thread-Topic: [PATCH] ARC: Fix __udelay calculation
Thread-Index: AQHOpWc1gBVbjN4s5EGQ4JJxLczBug==
Date: Fri, 30 Aug 2013 11:13:31 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075141223@IN01WEMBXA.internal.synopsys.com>
References: <1377856585-11078-1-git-send-email-mjonker@synopsys.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.237]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 03:26 PM, Mischa Jonker wrote:
> Cast usecs to u64, to ensure that the (usecs * 4295 * HZ)
> multiplication is 64 bit.
>
> Initially, the (usecs * 4295 * HZ) part was done as a 32 bit
> multiplication, with the result casted to 64 bit. This led to some bits
> falling off, causing a "DMA initialization error" in the stmmac Ethernet
> driver, due to a premature timeout.
>
> Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
>

Applied.

Thx,
-Vineet
