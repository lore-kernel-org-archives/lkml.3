Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935772Ab3DIJEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:04:49 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:62148 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934875Ab3DIJEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:04:48 -0400
Message-ID: <5163D9B2.9060603@prisktech.co.nz>
Date: Tue, 09 Apr 2013 21:04:50 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sachin Kamat <sachin.kamat@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the gpio-lw
 tree
References: <20130409174747.873a9c9cad1cd6a4dbe4014f@canb.auug.org.au>
In-Reply-To: <20130409174747.873a9c9cad1cd6a4dbe4014f@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/13 19:47, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/gpio/gpio-vt8500.c between commit 808c513ee64b ("gpio/vt8500:
> Convert to devm_ioremap_resource()") from the gpio-lw tree and commit
> dc1010860b03 ("gpio: vt8500: Remove arch-vt8500 gpio driver") from the
> arm-soc tree.
>
> The latter removed the file, so I did that and can carry the fix as
> necessary (no action is required).
>
That's the correct solution

Regards
Tony P

