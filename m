Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab3LPTSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 14:18:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46602 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab3LPTSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 14:18:06 -0500
Message-ID: <52AF51EA.8090400@infradead.org>
Date: Mon, 16 Dec 2013 11:18:02 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>, linux-kernel@vger.kernel.org
CC: David Herrmann <dh.herrmann@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] Input: fix typos in Documentation/input/gamepad.txt
References: <1387197292-29909-1-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1387197292-29909-1-git-send-email-ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/13 04:34, Antonio Ospite wrote:
> Fix some typos and while at it also use "PS" as the name for the central
> "HOME" button on Sony controllers, this is how Sony itself calls it.
> 
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

                                  advise

>  
>  All new gamepads are supposed to comply with this mapping. Please report any
>  bugs, if they don't.


-- 
~Randy
