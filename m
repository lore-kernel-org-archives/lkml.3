Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967133Ab3DRKoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:44:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53664 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966725Ab3DRKoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:44:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 0/9] Fix ux500 crypto drivers and init DMA in the correct way
Date: Thu, 18 Apr 2013 12:44:23 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181244.24036.arnd@arndb.de>
X-Provags-ID: V02:K0:qyAJHVQuSlKg8fRuo9r96SkUUjiXaLVnG0mq91chp94
 /xIRI2h4XgXVkiAKWlAZ0K+gPYCJEZ8v2oDTuWZIXjDm6zs8K7
 yoM9rmBcYA35yEJ9uBkY5Tm40BwPLGRgE3rNX5Rp2mYZljHQ2P
 Vm6nm6D1C0WeymwQXK3ZGD1GbF6aUsFsv+IFYb8rzzPoweJ+oH
 wzkwzoFEL+lIYLF6EjE6/ma/om3rySHm6BI7UarU8dy5UznrwQ
 e/wUve4gWlAGRtAuaB/uzrZvkum+fdQXgVT83WxOwVNLMvup+8
 GhveCDrLNs08Yvf9KYtLH6xPBaRvkA9f7IBaixThG4W1RU2Wt7
 xPAa2XaL3xGSvT2pda+Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Lee Jones wrote:
> These drivers haven't been touched in a while. They didn't even compile
> or probe successfully. After these changes, both drivers run just fine.
> 
> We also split DMA channel allocation and configuration into separate
> invocations, as the API expects.

Very nice series!

Acked-by: Arnd Bergmann <arnd@arndb.de>
