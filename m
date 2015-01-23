Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbbAWA6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:58:46 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34137 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbbAWA6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:58:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFuJxSmdP09s_kLMx2_+qc=XLHX65jMbAWy66vmADsswRgg@mail.gmail.com>
References: <1421973429-9663-1-git-send-email-mopsfelder@gmail.com> <CAAVeFuJxSmdP09s_kLMx2_+qc=XLHX65jMbAWy66vmADsswRgg@mail.gmail.com>
From: =?ISO-8859-1?Q?Murilo_Opsfelder_Ara=FAjo?= <mopsfelder@gmail.com>
Date: Thu, 22 Jan 2015 22:58:01 -0200
Message-ID: <CA+LKeY5MD61dqMsf_zGRz2a8qY-1773vvbBfy6FDoQ73D+V2hg@mail.gmail.com>
Subject: Re: [PATCH] gpio: sx150x: Fix compile issue when CONFIG_OF_GPIO is
 not defined
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "wei.chen" <Wei.Chen@csr.com>, "baohua.song" <Baohua.Song@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 10:45 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
[...]
> Linus just sent a patch to fix this, see
> http://patchwork.ozlabs.org/patch/431704/

Nice to know it has already been addressed.  Thanks for the link, Alexandre.

-- 
Murilo
