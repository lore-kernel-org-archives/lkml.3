Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965889AbaDJRU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 13:20:29 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:60246 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965191AbaDJRU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 13:20:28 -0400
MIME-Version: 1.0
In-Reply-To: <1396532873.15484.5.camel@phoenix>
References: <1396532873.15484.5.camel@phoenix>
Date: Thu, 10 Apr 2014 19:20:28 +0200
Message-ID: <CACRpkdbNKz1R8pR9fw8jvbYFZEK5hBQQu6x-RvwWjkaU2deg6A@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: lantiq: Fix header file include guard
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: John Crispin <blogic@openwrt.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2014 at 3:47 PM, Axel Lin <axel.lin@ingics.com> wrote:

> Define __PINCTRL_LANTIQ_H to prevent multiple inclusion.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Patch applied.

Yours,
Linus Walleij
