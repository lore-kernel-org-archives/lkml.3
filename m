Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965048AbaLLIop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:44:45 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:60968 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759079AbaLLIon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:44:43 -0500
MIME-Version: 1.0
In-Reply-To: <1418230767-24597-1-git-send-email-linux@roeck-us.net>
References: <1418230767-24597-1-git-send-email-linux@roeck-us.net>
Date: Fri, 12 Dec 2014 16:44:42 +0800
X-Google-Sender-Auth: RBTRdUoWSomnKyz2wdGhH_LxUyk
Message-ID: <CAFiDJ5-aY57yTnTfy5FxMFD45QV=W8uZmmAAERX3mWOAP6U9hA@mail.gmail.com>
Subject: Re: [PATCH] nios2: add definition of ioremap_wc to io.h
From: Ley Foon Tan <lftan@altera.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "nios2-dev@lists.rocketboards.org" <nios2-dev@lists.rocketboards.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 12:59 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> Fix
>
> drivers/gpu/drm/drm_bufs.c: In function 'drm_addmap_core':
> drivers/gpu/drm/drm_bufs.c:213:5:
>                         error: implicit declaration of function 'ioremap_wc'
>
> seen when building nios2:allmodconfig.
>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
Applied.

Thanks.
