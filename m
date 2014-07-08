Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaGHH3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:29:14 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:60116 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbaGHH3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:29:13 -0400
MIME-Version: 1.0
In-Reply-To: <1403799531-20526-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1403799531-20526-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Tue, 8 Jul 2014 09:29:12 +0200
Message-ID: <CACRpkdbJvDMi54Zvg=NOK=fEN6KH8NnV-5x2=xe6rrGW_d4A8Q@mail.gmail.com>
Subject: Re: [PATCH] gpio: gpio-ucb1400.c: Cleaning up null pointer checks
 that could never happen
From: Linus Walleij <linus.walleij@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 6:18 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:

> Removal of null pointer checks that could never happen
>
> This was found using a static code analysis program called cppcheck
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Correct, patch applied.

Yours,
Linus Walleij
