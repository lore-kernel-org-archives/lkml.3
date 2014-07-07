Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbaGGPgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:36:44 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:45878 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaGGPgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:36:42 -0400
MIME-Version: 1.0
In-Reply-To: <1403782005-9853-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1403782005-9853-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Mon, 7 Jul 2014 17:36:41 +0200
Message-ID: <CACRpkdZBCo9pw4sOiUaFQ2sJG5egEZ_VLekdCZ-PkyaTdL87gw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-at91.c: Cleaning up if unsigned is less
 than zero
From: Linus Walleij <linus.walleij@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 1:26 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:

> Remove checking if a unsigned is less than zero
>
> This was found using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Patch applied. Thanks!

Yours,
Linus Walleij
