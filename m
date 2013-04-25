Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab3DYVmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 17:42:18 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:63912 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707Ab3DYVmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 17:42:16 -0400
MIME-Version: 1.0
In-Reply-To: <51713B7B.3060402@neotion.com>
References: <51713B7B.3060402@neotion.com>
Date: Thu, 25 Apr 2013 23:42:15 +0200
Message-ID: <CACRpkdYsZgrGtog9-DDgW4PB7SaMgNjRKr=Uh3PKo+_AcoGeRg@mail.gmail.com>
Subject: Re: [PATCH 1/3] Add BOOT_PARTITION_ENABLE definition to MMC EXT_CSD PART_CONFIG
From: Linus Walleij <linus.walleij@linaro.org>
To: narmstrong@neotion.com
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Namjae Jeon <linkinjeon@gmail.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Loic PALLARDY <loic.pallardy@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 2:41 PM, Neil Armstrong <narmstrong@neotion.com> wrote:

> Add bit mask for the BOOT_PARTITION_ENABLE values.
>
> Signed-off-by: Neil Armstrong <narmstrong@neotion.com>

Loic (CC) pushed these boot partition changes so make sure he gets
to review them...

Yours,
Linus Walleij
