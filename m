Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684AbaFIQrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:47:01 -0400
Received: from smtprelay0184.hostedemail.com ([216.40.44.184]:44680 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933567AbaFIQq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:46:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3871:4321:5007:7
X-HE-Tag: wash37_3bd6675f5af59
X-Filterd-Recvd-Size: 1947
Message-ID: <1402332409.3142.2.camel@joe-AO725>
Subject: Re: [PATCH v3 1/3] crypto: qce: Qualcomm crypto engine driver
From: Joe Perches <joe@perches.com>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Date: Mon, 09 Jun 2014 09:46:49 -0700
In-Reply-To: <1402315720-5042-2-git-send-email-svarbanov@mm-sol.com>
References: <1402315720-5042-1-git-send-email-svarbanov@mm-sol.com>
	 <1402315720-5042-2-git-send-email-svarbanov@mm-sol.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-09 at 15:08 +0300, Stanimir Varbanov wrote:
> The driver is separated by functional parts. The core part
> implements a platform driver probe and remove callbaks.
> The probe enables clocks, checks crypto version, initialize
> and request dma channels, create done tasklet and init
> crypto queue and finally register the algorithms into crypto
> core subsystem.

trivia:

> diff --git a/drivers/crypto/qce/dma.h b/drivers/crypto/qce/dma.h
[]
> +#define AUTH_NONCE_NUM_WORDS_SHIFT	20
> +#define AUTH_NONCE_NUM_WORDS_MASK	GENMASK(22, 20);

Unnecessary semicolon and appears to be unused.

