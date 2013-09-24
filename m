Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab3IXTTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 15:19:46 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:52405 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab3IXTTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 15:19:44 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>, kgene.kim@samsung.com,
        t.stanislaws@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk, s.nawrocki@samsung.com,
        b.zolnierkie@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, ben-linux@fluff.org,
        m.szyprowski@samsung.com
Subject: Re: [PATCH v2] ARM: SAMSUNG: S5P: If detected device tree skip irq init
Date: Tue, 24 Sep 2013 21:19:42 +0200
Message-ID: <2123658.6S6hP57GRg@flatron>
User-Agent: KMail/4.11.1 (Linux/3.11.1-gentoo; KDE/4.11.1; x86_64; ; )
In-Reply-To: <1380038363-487-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1380038363-487-1-git-send-email-m.krawczuk@partner.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mateusz,

On Tuesday 24 of September 2013 17:59:23 Mateusz Krawczuk wrote:
> It prevents from executing things already handled by pinctrl-exynos
> driver, when device tree is available.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/plat-samsung/s5p-irq-eint.c | 4 ++++
>  1 file changed, 4 insertions(+)

Acked-by: Tomasz Figa <t.figa@samsung.com>

[as a temporary solution until we move all the users of this code to 
device tree]

Best regards,
Tomasz

