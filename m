Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbaBMNIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 08:08:23 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:56784 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaBMNIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 08:08:22 -0500
MIME-Version: 1.0
In-Reply-To: <1392138636-29240-7-git-send-email-pawel.moll@arm.com>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
	<1392138636-29240-7-git-send-email-pawel.moll@arm.com>
Date: Thu, 13 Feb 2014 14:08:21 +0100
Message-ID: <CACRpkdZjrCdhyBMF2WbDCnHuuMSpcpwiPx2k555PY3yBwdc1aw@mail.gmail.com>
Subject: Re: [PATCH 06/12] mfd: vexpress-sysreg: Add labels to gpio banks
From: Linus Walleij <linus.walleij@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 6:10 PM, Pawel Moll <pawel.moll@arm.com> wrote:

> ... so debugfs interfaces are easier to use.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>

This doesn't apply to the v3.14-rc1-based GPIO tree. Can you rebase it
with Lee's ACK so I can apply this?

Yours,
Linus Walleij
