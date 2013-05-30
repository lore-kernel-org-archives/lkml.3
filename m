Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000Ab3E3Sra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:47:30 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:36251 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab3E3SrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:47:21 -0400
MIME-Version: 1.0
In-Reply-To: <1369394486-26225-1-git-send-email-nbalandin@dev.rtsoft.ru>
References: <1369394486-26225-1-git-send-email-nbalandin@dev.rtsoft.ru>
Date: Thu, 30 May 2013 20:47:21 +0200
Message-ID: <CACRpkdZFj4LXB6NDFerVTNYJvdt04VvD0cYiz=1dL+LSXLWg=A@mail.gmail.com>
Subject: Re: [PATCH] gpio: sx150x: use devm_kzalloc()
From: Linus Walleij <linus.walleij@linaro.org>
To: Nikolay Balandin <n.a.balandin@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Nikolay Balandin <nbalandin@dev.rtsoft.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 1:21 PM, Nikolay Balandin
<n.a.balandin@gmail.com> wrote:

> Use devm_kzalloc() to make cleanup paths simpler.
>
> Signed-off-by: Nikolay Balandin <nbalandin@dev.rtsoft.ru>

You forgot to remove the kfree(chip); in sx150x_remove().

Yours,
Linus Walleij
