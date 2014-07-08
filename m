Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaGHH1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:27:15 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:65268 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbaGHH1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:27:13 -0400
MIME-Version: 1.0
In-Reply-To: <1403799441-20362-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1403799441-20362-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Tue, 8 Jul 2014 09:27:13 +0200
Message-ID: <CACRpkdaa=1Y-XiOaf_e1OjMFkOdJ4SJbJGDEUu-e4puzvr+opA@mail.gmail.com>
Subject: Re: [PATCH] gpio: gpio-twl4030.c: Cleaning up null pointer checks
 that could never happen
From: Linus Walleij <linus.walleij@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 6:17 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:

> Removal of null pointer checks that could never happen
>
> This was found using a static code analysis program called cppcheck
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

That's correct. Patch applied!

Yours,
Linus Walleij
