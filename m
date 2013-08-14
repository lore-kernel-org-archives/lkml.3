Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257Ab3HNTk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:40:28 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:56926 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758765Ab3HNTk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:40:26 -0400
MIME-Version: 1.0
In-Reply-To: <1376073495-28730-1-git-send-email-blogic@openwrt.org>
References: <1376073495-28730-1-git-send-email-blogic@openwrt.org>
Date: Wed, 14 Aug 2013 21:40:26 +0200
Message-ID: <CACRpkdYAG=qc-iOYWpFF+_Jk5fQwo2prex63vqGOiguEVg5PNA@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] pinctrl/lantiq: add missing pin definition to
 falcon pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: John Crispin <blogic@openwrt.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mips@linux-mips.org, Thomas Langer <thomas.langer@lantiq.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 9, 2013 at 8:38 PM, John Crispin <blogic@openwrt.org> wrote:

> From: Thomas Langer <thomas.langer@lantiq.com>
>
> The pps pin definition is missing in the current code.
>
> Signed-off-by: Thomas Langer <thomas.langer@lantiq.com>
> Acked-by: John Crispin <blogic@openwrt.org>
> ---
> Sorry i just noticed that i sent the 2 wrong files yesterday

OK applied this instead then.

Yours,
Linus Walleij
