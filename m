Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab3C0OER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:04:17 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:54317 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3C0OEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:04:16 -0400
MIME-Version: 1.0
In-Reply-To: <1363407672.3898.1.camel@phoenix>
References: <1363407672.3898.1.camel@phoenix>
Date: Wed, 27 Mar 2013 15:04:16 +0100
Message-ID: <CACRpkdbKVnNvRYQPrPKXYKWiiyhwLM75Jdji_HqGCta+mcQHVQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] gpio: samsung: Add terminating entry for exynos_pinctrl_ids
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 5:21 AM, Axel Lin <axel.lin@ingics.com> wrote:

> The of_device_id table is supposed to be zero-terminated.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Patch applied with Kukjin's ACK.

Thanks!
Linus Walleij
