Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbaBUAbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:31:40 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:49101 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360AbaBUAbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 19:31:37 -0500
Date: Fri, 21 Feb 2014 08:31:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, svarbanov@mm-sol.com
Subject: Re: [PATCH v3] hwrng: msm: switch Kconfig to ARCH_QCOM depends
Message-ID: <20140221003127.GA24448@gondor.apana.org.au>
References: <1392933533-10191-1-git-send-email-galak@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392933533-10191-1-git-send-email-galak@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 03:58:53PM -0600, Kumar Gala wrote:
> We've split Qualcomm MSM support into legacy and multiplatform.  The RNG
> driver is only relevant on the multiplatform supported SoCs so switch the
> Kconfig depends to ARCH_QCOM.
> 
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: Stanimir Varbanov <svarbanov@mm-sol.com>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
