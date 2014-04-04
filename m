Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaDDJX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 05:23:26 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62743 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaDDJXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 05:23:20 -0400
Message-ID: <533E7A05.9060806@linaro.org>
Date: Fri, 04 Apr 2014 10:23:17 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Stanimir Varbanov <svarbanov@mm-sol.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 2/9] crypto: qce: Add register defines
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com> <1396541886-10966-3-git-send-email-svarbanov@mm-sol.com>
In-Reply-To: <1396541886-10966-3-git-send-email-svarbanov@mm-sol.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Minor nitpicks.

On 03/04/14 17:17, Stanimir Varbanov wrote:
> +#define REQ_SIZE			17 /* bit 20-17 */

I would have defined macros like this with _SHIFT at the end, something 
like this:

#define REQ_SIZE_SHIFT 		17

> +#define REQ_SIZE_MASK			(0xf << REQ_SIZE)
You could possibly use GENMASK macro for this, its much readable, in 
*some cases* it could reduce few more lines in header too.

#define REQ_SIZE_MASK		GENMASK(20, 17)


My comments are equally applicable to most macros in this header file.

--
srini
Linaro Qualcomm Landing Team.
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

