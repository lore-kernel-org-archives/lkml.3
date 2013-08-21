Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab3HUVTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:19:19 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:38464 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3HUVTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:19:17 -0400
MIME-Version: 1.0
In-Reply-To: <1376829262.3391.1.camel@phoenix>
References: <1376829262.3391.1.camel@phoenix>
Date: Wed, 21 Aug 2013 23:19:17 +0200
Message-ID: <CACRpkdZPgWB8ZvbghKyuQ+vQh-jV1ejF1Rap8=YvgnEFpVLD+Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: core: Hold pinctrldev_list_mutex mutex while
 traversing pinctrldev_list
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 2:34 PM, Axel Lin <axel.lin@ingics.com> wrote:

> This one is missed in commit 44d5f7bb "pinctrl: sink pinctrldev_list_mutex".
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Good catch Axel!

Patch applied.

Yours,
Linus Walleij
