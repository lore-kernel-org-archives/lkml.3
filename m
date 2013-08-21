Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab3HUV3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:29:48 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:43368 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab3HUV3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:29:46 -0400
MIME-Version: 1.0
In-Reply-To: <1376829813.3391.7.camel@phoenix>
References: <1376829813.3391.7.camel@phoenix>
Date: Wed, 21 Aug 2013 23:29:46 +0200
Message-ID: <CACRpkdaQMEg2LARdLK_mfe2q=aTTK-2np0xXGTnee8VfZtzQ0A@mail.gmail.com>
Subject: Re: [PATCH] Documentation: pinctrl: Fix example code for pinctrl_register
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 2:43 PM, Axel Lin <axel.lin@ingics.com> wrote:

> pinctrl_register() returns NULL on error, fix it.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Patch applied.

Yours,
Linus Walleij
