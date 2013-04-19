Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030269Ab3DSMYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:24:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57538 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968238Ab3DSMYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:24:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 4/9 v2] crypto: ux500/cryp - Prepare clock before enabling it
Date: Fri, 19 Apr 2013 14:23:57 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Westin <andreas.westin@stericsson.com>,
        linux-crypto@vger.kernel.org
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org> <1366280825-31136-5-git-send-email-lee.jones@linaro.org> <20130419122226.GB3432@gmail.com>
In-Reply-To: <20130419122226.GB3432@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304191423.57261.arnd@arndb.de>
X-Provags-ID: V02:K0:hXfeOnz7A8SsBwjMQ9EFz/iXqCm0Jgkk2wmBZUIvRp1
 bmjCwhpaUsz7k5DHokezTWxSVCAsyZqxcCugd7CHiXVq+Kb/8p
 mxKdC2I4SlCmLhxubfEQQYZAmTAWg0T/RTB1eNHO81gG0ovJdq
 jNWwYtmzk+eelovPc3BocmnG0RCljPiyiJ+NFWLlasyfCyngj7
 WjH41FqzYX8CwUqh/Ckf2+yS3fjPHilFeN1tkBStSMWpHDkt30
 pYtv9UqRAsrgyGAsnDlN7pNolOUMj5YMp35SmSo/CveSkFtVx5
 PTWxWChUXW30irgEE+B3HCdZmaSB6kZL4Mgx//bnE3/H4fSTIi
 gdf7WCGDK+6kXGjftxqk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 April 2013, Lee Jones wrote:
> Slight change of plan for v2.
> 
> Now we're doing a seperate clk_prepare(), as the clk_enable() in the
> previous patch turned out to be called inside a spin_lock().
> 
> Arnd, can you confirm your Ack please?
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
