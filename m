Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab3ALXJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 18:09:49 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34271 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab3ALXJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 18:09:47 -0500
MIME-Version: 1.0
In-Reply-To: <1358030383-15609-1-git-send-email-xose.vazquez@gmail.com>
References: <1358030383-15609-1-git-send-email-xose.vazquez@gmail.com>
Date: Sun, 13 Jan 2013 00:09:46 +0100
Message-ID: <CAFLxGvxTenzaaypsUz6pYmjiyEeUtkNGDKwBNeAVFUb5ZZgonQ@mail.gmail.com>
Subject: Re: [PATCH] linux-firmware: add MISSING file
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Daniel Drake <dsd@laptop.org>, Ulrich Kunitz <kune@deine-taler.de>,
        David Woodhouse <dwmw2@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 11:39 PM, Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
> to document the reason why a firmware is not present
>
> Cc: Daniel Drake <dsd@laptop.org>
> Cc: Ulrich Kunitz <kune@deine-taler.de>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Ben Hutchings <ben@decadent.org.uk>
> Cc: <linux-wireless@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  MISSING | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>  create mode 100644 MISSING
>
> diff --git a/MISSING b/MISSING
> new file mode 100644
> index 0000000..f228099
> --- /dev/null
> +++ b/MISSING
> @@ -0,0 +1,20 @@
> +             ***********
> +             * MISSING *
> +             ***********
> +
> +This file attempts to document the reason why a firmware is not present
> +in this bundle.

>From the user's point of view this not really helpful.
Wouldn't a in-kernel table of known but missing firmware files make more sense?
The kernel could write a log like "Yeah, I know this firmware but
sadly I don't have it because of ..."

-- 
Thanks,
//richard
