Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaGGPuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:50:17 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:39095 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaGGPuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:50:13 -0400
MIME-Version: 1.0
In-Reply-To: <1403790181-11506-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1403790181-11506-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Mon, 7 Jul 2014 17:50:12 +0200
Message-ID: <CACRpkdbt1mJ7tn_-WhmySfpPFHPLFYsmHV8mMgspWzem_=v9ZQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-single.c: Cleaning up values that are
 never used
From: Linus Walleij <linus.walleij@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        ext Tony Lindgren <tony@atomide.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 3:43 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:

> Remove variable that are never used
>
> This was found using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Makes sense.

Patch applied unless Tony or Haojian has some better error handling cooking.

Yours,
Linus Walleij
