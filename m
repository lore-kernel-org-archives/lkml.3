Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab3GURic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 13:38:32 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:35509 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab3GURib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 13:38:31 -0400
MIME-Version: 1.0
In-Reply-To: <1372841090-14750-1-git-send-email-ian.campbell@citrix.com>
References: <1372841090-14750-1-git-send-email-ian.campbell@citrix.com>
Date: Sun, 21 Jul 2013 19:38:30 +0200
Message-ID: <CACRpkdZ5xEZ-axTBjpj6sRV+ATy8PXkkUqc-CP4N+=utA2QPzw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: am33xx dt binding: correct include path
From: Linus Walleij <linus.walleij@linaro.org>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 10:44 AM, Ian Campbell <ian.campbell@citrix.com> wrote:

> Using #include <include/...> is a bit odd. It happens to work because the DTC
> flags include -Iarch/FOO/boot/dts as well as arch/FOO/boot/dts/include and
> arch/FOO/boot/dts/include/dt-bindings is a symlink to include/dt-bindings.
>
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: linux-kernel@vger.kernel.org

Patch applied for pinctrl fixes, thanks.

Yours,
Linus Walleij
