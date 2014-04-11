Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaDKEDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 00:03:31 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:51452 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaDKED3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 00:03:29 -0400
MIME-Version: 1.0
In-Reply-To: <1397124377-16969-7-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
	<1397124377-16969-7-git-send-email-cw00.choi@samsung.com>
Date: Fri, 11 Apr 2014 09:33:28 +0530
Message-ID: <CAK9yfHxdeJarGCYgLADpxYS3BtxLt6hg0NJBrdYqrcKctFqU1g@mail.gmail.com>
Subject: Re: [PATCH 15/27] ARM: dts: exynos3250: Add uart dt node to support
 seiral ports
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 April 2014 15:36, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> This patch add UART dt node for Exynos3250. Exynos3250 uses same UART IP
> of Exynos4 SoC and has only two independent channels.
>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> [Fix incorrect clock id by Tomasz Figa]
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---

typo in patch subject: s/seiral/serial

-- 
With warm regards,
Sachin
