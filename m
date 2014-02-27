Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaB0Iep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 03:34:45 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:54931 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaB0Ien (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 03:34:43 -0500
From: Peter Korsgaard <peter@korsgaard.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Herbert Xu'" <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
        "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        "'Peter Korsgaard'" <jacmet@sunsite.dk>
Subject: Re: [PATCH 1/5] hwrng: atmel - Use devm_clk_get()
References: <003e01cf3378$c9f54420$5ddfcc60$%han@samsung.com>
Date: Thu, 27 Feb 2014 09:34:35 +0100
In-Reply-To: <003e01cf3378$c9f54420$5ddfcc60$%han@samsung.com> (Jingoo Han's
	message of "Thu, 27 Feb 2014 14:00:09 +0900")
Message-ID: <8738j5ar8k.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jingoo" == Jingoo Han <jg1.han@samsung.com> writes:

 > Use devm_clk_get() to make cleanup paths simpler.
 > Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Peter Korsgaard <peter@korsgaard.com>


-- 
Bye, Peter Korsgaard
