Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbaHGJzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:55:36 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:45835 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757487AbaHGJzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:55:33 -0400
MIME-Version: 1.0
In-Reply-To: <1407125156-14269-1-git-send-email-acourbot@nvidia.com>
References: <1407125156-14269-1-git-send-email-acourbot@nvidia.com>
Date: Thu, 7 Aug 2014 11:55:32 +0200
Message-ID: <CACRpkdZXxwRF7=HiOasPRecGuYFX3zzbSL192ynF8gXN=2W4Pw@mail.gmail.com>
Subject: Re: [PATCH] gpio: add missing includes in machine.h
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Thierry Reding <treding@nvidia.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2014 at 6:05 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> linux/types.h and linux/list.h should be included so the typed used in
> the header file are always properly declared.
>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Reported-by: Thierry Reding <treding@nvidia.com>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Patch applied, preparing for the v3.17 pull request.

Yours,
Linus Walleij
