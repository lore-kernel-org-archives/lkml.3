Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab3CGIEC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 03:04:02 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:53248 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3CGIEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 03:04:00 -0500
MIME-Version: 1.0
In-Reply-To: <1362582765-25251-2-git-send-email-maxime.ripard@free-electrons.com>
References: <1362582765-25251-1-git-send-email-maxime.ripard@free-electrons.com>
	<1362582765-25251-2-git-send-email-maxime.ripard@free-electrons.com>
Date: Thu, 7 Mar 2013 09:03:59 +0100
Message-ID: <CACRpkdbATpdX76OKveWpobOPMPZQgSJW04HYEawZ9M8seb+yqQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: sunxi: Add Allwinner A10 pin functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 4:12 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> The initial driver contained only a limited set of pins functions
> because we lacked of documentation on it.
>
> Now that we have such documentation, finish to fill the array.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Patch applied, thanks.

I was to Shenzhen yesterday and had a look at the plethora of
Allwinner-based tablets, which makes me ever more interested in
supporting this chip. It's really starting to take off...

Yours,
Linus Walleij
