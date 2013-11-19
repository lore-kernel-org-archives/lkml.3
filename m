Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab3KSIYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:24:21 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:64154 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab3KSIYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:24:18 -0500
MIME-Version: 1.0
In-Reply-To: <1384374039-18795-1-git-send-email-mpn@google.com>
References: <1384374039-18795-1-git-send-email-mpn@google.com>
Date: Tue, 19 Nov 2013 09:24:18 +0100
Message-ID: <CACRpkda=a0=vpjg5_ZL0_jq--sArSG34iPjeb+jHS5WAs4HA8A@mail.gmail.com>
Subject: Re: [PATCH] gpio: fix memory leak in error path
From: Linus Walleij <linus.walleij@linaro.org>
To: Michal Nazarewicz <mpn@google.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Ruppert <christian.ruppert@abilis.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 9:20 PM, Michal Nazarewicz <mpn@google.com> wrote:

> From: Michal Nazarewicz <mina86@mina86.com>
>
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>

Good catch!

Patch applied.

Yours,
Linus Walleij
