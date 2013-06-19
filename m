Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934270Ab3FSIlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:41:09 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:52620 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934021Ab3FSIlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:41:06 -0400
MIME-Version: 1.0
In-Reply-To: <1371603747-27436-5-git-send-email-rvaswani@codeaurora.org>
References: <1371603747-27436-1-git-send-email-rvaswani@codeaurora.org>
	<1371603747-27436-5-git-send-email-rvaswani@codeaurora.org>
Date: Wed, 19 Jun 2013 10:41:05 +0200
Message-ID: <CACRpkdaLqOjVC=gv9UkqQq3djUWq=W0ehZNV-0qUhZLsY4XghQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] drivers: gpio: msm: Remove __devinit
From: Linus Walleij <linus.walleij@linaro.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 3:02 AM, Rohit Vaswani <rvaswani@codeaurora.org> wrote:

> Remove stray usage of __devinit as it has been removed.
>
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>

A patch for this is already merged.

Thanks,
Linus Walleij
