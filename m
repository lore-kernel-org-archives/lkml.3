Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaFVL6p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 07:58:45 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:65469 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbaFVL6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 07:58:43 -0400
Message-ID: <53A6C4EE.2020400@gmail.com>
Date: Sun, 22 Jun 2014 13:58:38 +0200
From: Corentin LABBE <clabbe.montjoie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        davem@davemloft.net, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v3 2/4] crypto: Update makefile and Kconfig for Security
 System
References: <1402404197-4236-1-git-send-email-clabbe.montjoie@gmail.com> <1402404197-4236-3-git-send-email-clabbe.montjoie@gmail.com> <201406142101.30546.marex@denx.de>
In-Reply-To: <201406142101.30546.marex@denx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 14/06/2014 21:01, Marek Vasut a écrit :
> On Tuesday, June 10, 2014 at 02:43:15 PM, LABBE Corentin wrote:
>> Add necessary changes for configuring and compiling the Security System
>> driver.
>>
>> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
>> ---
>>  drivers/crypto/Kconfig  | 91
>> +++++++++++++++++++++++++++++++++++++++++++++++++ drivers/crypto/Makefile
>> |  1 +
>>  2 files changed, 92 insertions(+)
> 
> This should be part of 1/4, otherwise 1/4 just adds dead code.
> 

If I do that 1/4 add to the makefile a path that do not exists.

But as you like I will change that.

