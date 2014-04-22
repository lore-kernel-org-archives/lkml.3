Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaDVMyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:54:13 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46794 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbaDVMyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:54:09 -0400
MIME-Version: 1.0
In-Reply-To: <1397653068-21788-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1397653068-21788-1-git-send-email-antoine.tenart@free-electrons.com>
Date: Tue, 22 Apr 2014 14:54:09 +0200
Message-ID: <CACRpkdbDVG=2N4xOqAAmX6UMd=CjSrs4gxdNzUPSm3pdHYYtaQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: sunxi: fix typo in module author address
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@free-electrons.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 2:57 PM, Antoine Ténart
<antoine.tenart@free-electrons.com> wrote:

> According to the MODULE_AUTHOR() comments, the author name should be
> "Name <email>" or just "Name". Add the missing '>'.
>
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>

Patch applied with Maxime's ACK.

Yours,
Linus Walleij
