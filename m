Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586Ab3CVIif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 04:38:35 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:40012 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350Ab3CVIid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 04:38:33 -0400
MIME-Version: 1.0
In-Reply-To: <201303051526.r25FQoCv002950@localhost.localdomain>
References: <201303051526.r25FQoCv002950@localhost.localdomain>
Date: Fri, 22 Mar 2013 09:38:33 +0100
Message-ID: <CACRpkdaETvQmEWSSp-Vj1tu-KVPBgWrKbMZbgTjmRt=7Yxxg6g@mail.gmail.com>
Subject: Re: [PATCH v2] Adds support for Open Firmware in MAX730x GPIO Driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Patrick Vasseur <patrick.vasseur@c-s.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 4:26 PM, Christophe Leroy
<christophe.leroy@c-s.fr> wrote:

> This patch allows the use of the MAX730x Driver on systems using
> the Open Firmware platform format.
> The bit_per_word can be set in the OF Device tree, so no need to force it as with
> the platform_data.
>
> Signed-off-by: Patrick Vasseur <patrick.vasseur@c-s.fr>
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

I tried applying this but it fails. Can you send based on e.g.
v3.9-rc3 or so?

Yours,
Linus Walleij
