Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab3DPSNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:13:52 -0400
Received: from gloria.sntech.de ([95.129.55.99]:56909 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab3DPSNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:13:51 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 1/2] gpio: samsung: Remove OF support for s3c24xx
Date: Tue, 16 Apr 2013 20:13:44 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: linus.walleij@linaro.org, grant.likely@secretlab.ca,
        kyungmin.park@samsung.com, kgene.kim@samsung.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
References: <1366134094-23140-1-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1366134094-23140-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201304162013.45134.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 16. April 2013, 19:41:34 schrieb Sylwester Nawrocki:
> There is no users of this code and there is already a pinctrl
> driver written for s3c24xx which is going to be used on any
> s3c24xx DT platforms. Hence this has been effectively a dead
> code in mainline.
> 
> This reverts commit 172c6a13653ac8cd6a231293b87c93821e90c1d6
> gpio: samsung: add devicetree init for s3c24xx arches
> 
> Cc: Heiko Stübner <heiko@sntech.de>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

This patch stems from a time where I thought pinctrl on s3c24xx would be ages 
away :-D, so

Acked-by: Heiko Stuebner <heiko@sntech.de>
