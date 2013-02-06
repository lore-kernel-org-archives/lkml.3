Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab3BFJd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 04:33:58 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:40496 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3BFJdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 04:33:53 -0500
MIME-Version: 1.0
In-Reply-To: <1360128076-8555-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1360128076-8555-1-git-send-email-iamjoonsoo.kim@lge.com>
Date: Wed, 6 Feb 2013 10:33:53 +0100
Message-ID: <CACRpkdbwoExxKbbvBKpt_Wh9KsgCXQW566N-0BaeL3oGY8pvLg@mail.gmail.com>
Subject: Re: [PATCH RESEND] ARM: sched: correct update_sched_clock()
From: Linus Walleij <linus.walleij@linaro.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        js1304@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 6:21 AM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> If we want load epoch_cyc and epoch_ns atomically,
> we should update epoch_cyc_copy first of all.
> This notify reader that updating is in progress.

If you think the patch is finished, put it into Russell's patch tracker:
http://www.arm.linux.org.uk/developer/patches/

Yours,
Linus Walleij
