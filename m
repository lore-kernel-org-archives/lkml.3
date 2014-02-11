Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaBKLza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 06:55:30 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:59626 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaBKLz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:55:29 -0500
MIME-Version: 1.0
In-Reply-To: <20140211114048.GO32042@lee--X1>
References: <1392114599-481-1-git-send-email-linus.walleij@linaro.org>
	<20140211114048.GO32042@lee--X1>
Date: Tue, 11 Feb 2014 12:55:28 +0100
Message-ID: <CACRpkdb5yFJ+3m9+7xz-zwKabq5fdyHE-Uaj=u8SDbiwAoEB1w@mail.gmail.com>
Subject: Re: [PATCH] mfd: dbx500/abx500: root out hardcoded IRQ assignments
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 12:40 PM, Lee Jones <lee.jones@linaro.org> wrote:

>> Sam/Lee: I'm looking for an ACK on this to take the result through
>> ARM SoC.
>
> Actually I have a better idea. Gather all of the Acks/head-nods you
> need and I'll create an immutable branch for the pair of us to pull
> from.

OK that's a good idea, let's do like that after discussing this
patch.

Yours,
Linus Walleij
