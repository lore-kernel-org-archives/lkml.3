Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab3BNDL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:11:57 -0500
Received: from mail-ia0-f179.google.com ([209.85.210.179]:48493 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab3BNDL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:11:56 -0500
MIME-Version: 1.0
In-Reply-To: <511C1990.1090205@gmail.com>
References: <1360738983-22436-1-git-send-email-gnurou@gmail.com>
 <1360738983-22436-5-git-send-email-gnurou@gmail.com> <511C1990.1090205@gmail.com>
From: Alexandre Courbot <acourbot@nvidia.com>
Date: Thu, 14 Feb 2013 12:11:34 +0900
X-Google-Sender-Auth: dzhFfcIKHeXAIjN0okEPaNNfirQ
Message-ID: <CAAVeFuLLiA+J3wxXJ3K+w2KrLyfYkzvcV2oBzHLENtcbys3z8w@mail.gmail.com>
Subject: Re: [PATCH 4/4] gpiolib: rename local offset variables to "hwgpio"
To: Ryan Mallon <rmallon@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 7:54 AM, Ryan Mallon <rmallon@gmail.com> wrote:
> Nitpicky - Is it accurate to call these hardware numbers? Don't some of
> the platforms remap the gpio numbers? These numbers may not match
> against the platform's datasheet for example.

I'm following a suggestion by Grant and Linus W. here. This is closer
to existing convention in e.g. irqdomain.

Also at that level the GPIO numbers are local to the GPIO controller,
i.e. they are not supposed to be the GPIO numbers used by consumers
(or the datasheet for that instance).

Alex.
