Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab3LPNLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:11:15 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61198 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab3LPNLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:11:14 -0500
MIME-Version: 1.0
In-Reply-To: <1387197292-29909-1-git-send-email-ospite@studenti.unina.it>
References: <1387197292-29909-1-git-send-email-ospite@studenti.unina.it>
Date: Mon, 16 Dec 2013 14:03:43 +0100
Message-ID: <CANq1E4TUC-Gfu0nkjLOs0BEkxh37pWpqQodK88TW9o96ej5OiQ@mail.gmail.com>
Subject: Re: [PATCH] Input: fix typos in Documentation/input/gamepad.txt
From: David Herrmann <dh.herrmann@gmail.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Dec 16, 2013 at 1:34 PM, Antonio Ospite
<ospite@studenti.unina.it> wrote:
> Fix some typos and while at it also use "PS" as the name for the central
> "HOME" button on Sony controllers, this is how Sony itself calls it.

Thanks, looks good. Any news regarding the absolute DPad?

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> ---
>  Documentation/input/gamepad.txt | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/input/gamepad.txt b/Documentation/input/gamepad.txt
> index 4be7f21..63c0256 100644
> --- a/Documentation/input/gamepad.txt
> +++ b/Documentation/input/gamepad.txt
> @@ -71,7 +71,7 @@ features that you need, first. How each feature is mapped is described below.
>  Legacy drivers often don't comply to these rules. As we cannot change them
>  for backwards-compatibility reasons, you need to provide fixup mappings in
>  user-space yourself. Some of them might also provide module-options that
> -change the mappings so you can adivce users to set these.
> +change the mappings so you can advice users to set these.
>
>  All new gamepads are supposed to comply with this mapping. Please report any
>  bugs, if they don't.
> @@ -156,10 +156,10 @@ Menu-Pad:
>                    BTN_START
>    Many pads also have a third button which is branded or has a special symbol
>    and meaning. Such buttons are mapped as BTN_MODE. Examples are the Nintendo
> -  "HOME" button, the XBox "X"-button or Sony "P" button.
> +  "HOME" button, the XBox "X"-button or Sony "PS" button.
>
>  Rumble:
> -  Rumble is adverticed as FF_RUMBLE.
> +  Rumble is advertised as FF_RUMBLE.
>
>  Motion-tracking:
>    Motion-tracking is defined in ./Documentation/input/motion-tracking.txt and
> --
> 1.8.5.1
>
