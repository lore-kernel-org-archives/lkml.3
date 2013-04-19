Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030430Ab3DSM0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:26:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49361 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030355Ab3DSM0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:26:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/9 v2] crypto: ux500/hash - Prepare clock before enabling it
Date: Fri, 19 Apr 2013 14:26:37 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Westin <andreas.westin@stericsson.com>,
        linux-crypto@vger.kernel.org
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org> <1366280825-31136-2-git-send-email-lee.jones@linaro.org> <20130419122428.GC3432@gmail.com>
In-Reply-To: <20130419122428.GC3432@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304191426.37408.arnd@arndb.de>
X-Provags-ID: V02:K0:qm0AultiT0W2FhETy0CcZ9TaqxY9JoV+jYSWv4KJuW2
 kYN5DZf/3eyZoWIHtFNjd4q24e/4PfESomfUfAd9jGmHkUrs8q
 9ihmJLgeP1Y1KSXw2WVblcukfnpvy1slPnYlifQ5RhAH8mshJI
 5UPjk6MDSRWOe/WRyqR5L8On+wY7bZ0dhi/5McSHZtgXbymuhl
 0YfwrwcoJwxP8xpzCVTM6WIyyeHz35YYeTEFKlLhEdtgALiAzy
 XbJHepZs/23Qk6Q1QQ0Ft7WrV6EypXt1XpAYMVCVTe9G49X9L+
 /SZDoXsUbY+U1mIFqmebkjzrSyM/PgeLm/Sjphe2RGoFkB0SYY
 hFP4QC76A7AkkeI4DsjA=
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
