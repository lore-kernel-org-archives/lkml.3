Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbaDCOKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:10:49 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:40993 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbaDCOKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:10:47 -0400
MIME-Version: 1.0
In-Reply-To: <1395700561-3793-1-git-send-email-b.galvani@gmail.com>
References: <1395700561-3793-1-git-send-email-b.galvani@gmail.com>
Date: Thu, 3 Apr 2014 16:10:46 +0200
Message-ID: <CACRpkda9Lh19sfkxs3=dNWbg4FgkAtY2tJdMQik=TGs8wUkYfA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: rockchip: fix offset of mux registers for rk3188
From: Linus Walleij <linus.walleij@linaro.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Heiko Stuebner <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 11:36 PM, Beniamino Galvani <b.galvani@gmail.com> wrote:

> The correct value of .mux_offset for rk3188 seems to be 0x60
> instead of 0x68.
>
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>

Patch applied to fixes with Heiko's Review tag and also
copied some info from the conversation into the commit message.

Yours,
Linus Walleij
