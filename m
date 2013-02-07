Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab3BGPis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:38:48 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:45126 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab3BGPir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:38:47 -0500
MIME-Version: 1.0
In-Reply-To: <1360148051-7560-27-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
	<1360148051-7560-27-git-send-email-lee.jones@linaro.org>
Date: Thu, 7 Feb 2013 16:38:46 +0100
Message-ID: <CACRpkday18vC=HeWGAEsLpNtVQ3yB43eK57FVinvQmejeqrM=g@mail.gmail.com>
Subject: Re: [PATCH 26/49] ARM: ux500: Partially revert changes surrounding
 audio regulators
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Ola LILJA2 <ola.o.lilja@stericsson.com>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        Philippe Langlais <philippe.langlais@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 11:53 AM, Lee Jones <lee.jones@linaro.org> wrote:

> From: Philippe Langlais <philippe.langlais@linaro.org>
>
> Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

There is an awfully small commit blurb for this change. Actually
nothing. We need some explanation, and I want Ola to be in on this
change.

Yours,
Linus Walleij
