Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbaE3QAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:00:16 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:65480 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaE3QAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:00:14 -0400
MIME-Version: 1.0
In-Reply-To: <1401449826-30957-1-git-send-email-berthe.ab@gmail.com>
References: <20140530094025.3b78301e@canb.auug.org.au> <1401449826-30957-1-git-send-email-berthe.ab@gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sat, 31 May 2014 00:59:53 +0900
Message-ID: <CAAVeFuLMLfa-1RhcdSrKDUz7=eLqZurBSFSsN7N0x-0S+_btJA@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: removes all usage of gpiochip_remove retval
To: abdoulaye berthe <berthe.ab@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, m@bues.ch,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 8:37 PM, abdoulaye berthe <berthe.ab@gmail.com> wrote:
> The aim of this patch is to make gpiochip_remove() behavior consistent,
> especially when issuing a remove request while the chipio chip is still
> requested. It is the 1st patch in a serie af 2 patches. the 2nd patch
> changes the return value of gpiochip_remove() from int to void. This one
> updates users of the return value.

This comment belongs to a cover letter (PATCH 0/2), not to the first
patch of your series. Add --cover-letter to git format-patch to
produce one.
