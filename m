Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763331Ab3DCUqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 16:46:19 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:52686 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760396Ab3DCUqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 16:46:18 -0400
MIME-Version: 1.0
In-Reply-To: <1364908916-29803-8-git-send-email-lee.jones@linaro.org>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
	<1364908916-29803-8-git-send-email-lee.jones@linaro.org>
Date: Wed, 3 Apr 2013 22:46:17 +0200
Message-ID: <CACRpkdbQ0Zfd6vWisH-q1XcmPFqzQGtL8GzZpFyxbtGAoYT88A@mail.gmail.com>
Subject: Re: [PATCH 8/9] mfd: db8500-prcmu: Return early if the TCPM cannot be located
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Loic PALLARDY <loic.pallardy@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 3:21 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Currently we check to see if we obtained the Tightly Coupled Program
> Memory (TCPM) base and only execute the code within the check if we
> have it. It's more traditional to return early if we don't have it.
> This way we can flatten most of the function's code down to a single
> tab spacing.
>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

This should go in through the MFD tree.

Yours,
Linus Walleij
