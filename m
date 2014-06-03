Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaFCL0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:26:05 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:53428 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbaFCL0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:26:02 -0400
MIME-Version: 1.0
In-Reply-To: <1401627240-16524-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1401627240-16524-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Tue, 3 Jun 2014 13:26:02 +0200
Message-ID: <CACRpkdYsfM4YeMVHksE6if+SyFFUkFNtJHeBOnci8jwSY-49Jg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-abx500.c: Cleaning up uninitialized variables
From: Linus Walleij <linus.walleij@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 1, 2014 at 2:54 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:

> There is a risk that the variable will be used without being initialized.
>
> This was largely found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
