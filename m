Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab3HUVb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:31:28 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:44641 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3HUVb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:31:27 -0400
MIME-Version: 1.0
In-Reply-To: <1376877989.10251.2.camel@phoenix>
References: <1376877989.10251.2.camel@phoenix>
Date: Wed, 21 Aug 2013 23:31:26 +0200
Message-ID: <CACRpkdYdKBbD6qBeKxdFp8mcuPxNH+D1ZJFpm+VF4VARCpGneA@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: core: Remove unnecessary test for desc->name
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 4:06 AM, Axel Lin <axel.lin@ingics.com> wrote:

> The implementation in pinctrl_register_one_pin() ensures pindesc->name is always
> not NULL before insert the pindesc to radix tree.
> If the desc return from pin_desc_get is not NULL, desc->name is always not NULL.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Good point. Patch applied.

Yours,
Linus Walleij
