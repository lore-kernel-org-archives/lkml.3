Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaE0UZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:25:56 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:47013 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaE0UZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:25:55 -0400
MIME-Version: 1.0
In-Reply-To: <000201cf6dc6$3ed91500$bc8b3f00$@samsung.com>
References: <000201cf6dc6$3ed91500$bc8b3f00$@samsung.com>
Date: Tue, 27 May 2014 22:25:54 +0200
Message-ID: <CAMJs5B8MW_Abni2X=+bdywg9zz5JyaEcDmZ+0MLd79Pn1+ZYtg@mail.gmail.com>
Subject: Re: [PATCH v6 3/7] arm64: Add a description on 48-bit address space
 with 4KB pages
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Jungseok Lee <jays.lee@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Steve Capper <steve.capper@linaro.org>,
        =?UTF-8?B?7KCV7ISx7KeE?= <sungjinn.chung@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Kukjin Kim <kgene.kim@samsung.com>,
        Ilho Lee <ilho215.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 06:40:44PM +0900, Jungseok Lee wrote:
> This patch adds memory layout and translation lookup information
> about 48-bit address space with 4K pages. The description is based
> on 4 levels of translation tables.
>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Steve Capper <steve.capper@linaro.org>
> Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> ---

Looks reasonable to me:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
