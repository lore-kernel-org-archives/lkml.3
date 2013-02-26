Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759929Ab3BZT14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 14:27:56 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:65005 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187Ab3BZT1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 14:27:18 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 0/4] gpiolib: some fixup patches
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Ryan Mallon <rmallon@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "acourbot@nvidia.com" <acourbot@nvidia.com>
In-Reply-To: <CAAVeFuLP0KLVL-0SS+nGWSoK1RMPCmKgZV-OjMJo-h7E1UVuXw@mail.gmail.com>
References: <1360907177-6468-1-git-send-email-acourbot@nvidia.com> <CAAVeFuLP0KLVL-0SS+nGWSoK1RMPCmKgZV-OjMJo-h7E1UVuXw@mail.gmail.com>
Date: Tue, 26 Feb 2013 17:53:11 +0000
Message-Id: <20130226175311.D17173E2EF8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013 11:19:44 +0900, Alexandre Courbot <gnurou@gmail.com> wrote:
> Grant, will you be able to include these for 3.9? They fix code that
> you merged recently, so I'd be glad if they could be squashed into the
> patch mentioned in the description.

They won't get squashed in because the tree is already composed and in
linux-next. I don't rebase unless I really need to. I've applied them
and I'll probably push to Linus since they are effectively bug fixes of
a sort and the merge window hasn't closed yet.

g.
