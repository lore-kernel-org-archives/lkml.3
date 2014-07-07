Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaGGPiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:38:50 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64204 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaGGPit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:38:49 -0400
MIME-Version: 1.0
In-Reply-To: <1403782189-10027-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1403782189-10027-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Mon, 7 Jul 2014 17:38:48 +0200
Message-ID: <CACRpkdbc8zZqNaQfW5Kb2njs6kX7yURK0CxmkUsaZo8W9E19cA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-imx1-core.c: Cleaning up if unsigned is
 less than zero
From: Linus Walleij <linus.walleij@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 1:29 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:

> Remove checking if a unsigned is less than zero
>
> This was found using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Patch applied. Thanks!

Yours,
Linus Walleij
