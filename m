Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbaIWPdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:33:33 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:41931 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaIWPdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:33:32 -0400
MIME-Version: 1.0
In-Reply-To: <1410943745-9354-1-git-send-email-rebecca.swee.fun.chang@intel.com>
References: <1410943745-9354-1-git-send-email-rebecca.swee.fun.chang@intel.com>
Date: Tue, 23 Sep 2014 17:33:31 +0200
Message-ID: <CACRpkdYZEMdOM82tUE8RUNZF0rC=5vTOxVZEYd9Ns5tLWpYgzA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Enable Quark X1000 support in gpio-sch
From: Linus Walleij <linus.walleij@linaro.org>
To: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 10:49 AM, Chang Rebecca Swee Fun
<rebecca.swee.fun.chang@intel.com> wrote:

> This patch series is about enabling legacy GPIO support for Quark X1000.
> The patches were developed on top of Mika Westerberg's commit on
> consolidating core and resume banks. Please refer to the link below for
> more information about his commit.
> https://lkml.org/lkml/2014/8/17/13

I'm waiting for Mika's comments to be addressed for this patch
series before reviewing further.

Yours,
Linus Walleij
