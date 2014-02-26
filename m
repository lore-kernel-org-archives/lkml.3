Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbaBZTPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:15:15 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55812 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbaBZTPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:15:12 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: linux-next: manual merge of the crypto tree with the arm-soc tree
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20140226150159.7ea5e60285ee9d0193bde811@canb.auug.org.au>
Date: Wed, 26 Feb 2014 13:15:06 -0600
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B4102448-9875-4C8A-94A1-E2EDFC5011E2@codeaurora.org>
References: <20140226150159.7ea5e60285ee9d0193bde811@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 25, 2014, at 10:01 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Herbert,
> 
> Today's linux-next merge of the crypto tree got a conflict in
> drivers/char/hw_random/Kconfig between commit 2257ffbca73c ("hwrng: msm:
> switch Kconfig to ARCH_QCOM depends") from the arm-soc tree and commit
> f9bee046c915 ("hwrng: msm: switch Kconfig to ARCH_QCOM depends") from the
> crypto tree.
> 
> Two version of the same patch ... I just kept the arm-soc version.

Herbert,

Was trying to keep all the ARCH_QCOM Kconfig updates together and via arm-soc.git

thanks

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

