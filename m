Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbaFJIe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:34:29 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:33360 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbaFJIe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:34:26 -0400
Message-ID: <5396C30E.8090906@mm-sol.com>
Date: Tue, 10 Jun 2014 11:34:22 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 1/3] crypto: qce: Qualcomm crypto engine driver
References: <1402315720-5042-1-git-send-email-svarbanov@mm-sol.com>  <1402315720-5042-2-git-send-email-svarbanov@mm-sol.com> <1402332409.3142.2.camel@joe-AO725>
In-Reply-To: <1402332409.3142.2.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On 06/09/2014 07:46 PM, Joe Perches wrote:
> On Mon, 2014-06-09 at 15:08 +0300, Stanimir Varbanov wrote:
>> The driver is separated by functional parts. The core part
>> implements a platform driver probe and remove callbaks.
>> The probe enables clocks, checks crypto version, initialize
>> and request dma channels, create done tasklet and init
>> crypto queue and finally register the algorithms into crypto
>> core subsystem.
> 
> trivia:
> 
>> diff --git a/drivers/crypto/qce/dma.h b/drivers/crypto/qce/dma.h
> []
>> +#define AUTH_NONCE_NUM_WORDS_SHIFT	20
>> +#define AUTH_NONCE_NUM_WORDS_MASK	GENMASK(22, 20);
> 
> Unnecessary semicolon and appears to be unused.

Will correct, thanks.

It is unused because I dropped out AEAD support from this set. I plan to
add AEAD incrementally later on.

-- 
regards,
Stan
