Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab3IWK2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:28:17 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:63534 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab3IWK2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:28:15 -0400
MIME-Version: 1.0
In-Reply-To: <1379931289-29384-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1379931289-29384-1-git-send-email-m.krawczuk@partner.samsung.com>
Date: Mon, 23 Sep 2013 15:58:14 +0530
Message-ID: <CAK9yfHyKik0ZLsgikGUdOc7xPwPee=JNLCr5P3ZdKU6DA5j4Fg@mail.gmail.com>
Subject: Re: [PATCH] DT: if dt is available don't use s3c_arch_init
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mateusz,

On 23 September 2013 15:44, Mateusz Krawczuk
<m.krawczuk@partner.samsung.com> wrote:
> It prevents from executing platform code, when booting from device tree.
>
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---

nit: Please format the patch title appropriately. In this case, it
should start with
"ARM: SAMSUNG: ..."

-- 
With warm regards,
Sachin
