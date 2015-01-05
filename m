Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbbAENzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:55:15 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbbAENzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:55:13 -0500
Message-ID: <54AA97B9.7040703@nod.at>
Date: Mon, 05 Jan 2015 14:55:05 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Harald Geyer <harald@ccbib.org>, Jonathan Cameron <jic23@kernel.org>
CC: knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/3] iio: dht11: Fix out-of-bounds read
References: <1417563176-31972-1-git-send-email-richard@nod.at> <54A53FBF.5000003@kernel.org> <7e4f6a70e48afe96457ebbcf07572224@imap.cosmopool.net> <54A680F8.30209@nod.at> <54A91DA1.6080107@kernel.org> <E1Y881p-0001Fp-NX@stardust.g4.wien.funkfeuer.at>
In-Reply-To: <E1Y881p-0001Fp-NX@stardust.g4.wien.funkfeuer.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.01.2015 um 14:49 schrieb Harald Geyer:
> As we access i-1 we must not start with i=0.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> Acked-by: Hartmut Knaack <knaack.h@gmx.de>
> Acked-by: Harald Geyer <harald@ccbib.org>
> ---
> Resending for Richard Weinberger.
> No changes since v1 except reordering.

I fear you got the resend wrong.
The mail should be "From: Richard Weinberger <richard@nod.at>" to keep me
as author and the SoB-Chain should have a "Signed-off-by: Harald Geyer <harald@ccbib.org>"
at the end to indicate that this patch went though your hands.

Thanks,
//richard
