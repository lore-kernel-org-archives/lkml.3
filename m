Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaGHI3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:29:16 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:63624 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbaGHI3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:29:12 -0400
MIME-Version: 1.0
In-Reply-To: <1403992120-8160-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1403992120-8160-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Tue, 8 Jul 2014 10:29:12 +0200
Message-ID: <CACRpkdYgiJje6rzYO=VSoYGdAOZxYk3o9pdVhvSNSyy7V35gMQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-imx27.c: Cleaning up remove a struct
 that is unused
From: Linus Walleij <linus.walleij@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Alexander Shiyan <shc_work@mail.ru>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 11:48 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:

> Removal of a struct that is never used
>
> This was found using a static code analysis program called cppcheck
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Already removed in a similar patch from Alexander Shiyan, but thanks
anyway!

Yours,
Linus Walleij
