Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab3EXHAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 03:00:08 -0400
Received: from mail.southpole.se ([37.247.8.11]:41458 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737Ab3EXHAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 03:00:07 -0400
X-Greylist: delayed 1243 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 May 2013 03:00:07 EDT
Message-ID: <519F0B24.6050607@southpole.se>
Date: Fri, 24 May 2013 08:39:32 +0200
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] openrisc: Wire up asm-generic/xor.h
References: <1368516726-8035-1-git-send-email-geert@linux-m68k.org> <1368516726-8035-4-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1368516726-8035-4-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.2.2(12343) on assp.southpole.se
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 77559-12365
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 05/14/2013 09:32 AM, Geert Uytterhoeven wrote:
> crypto/xor.c:25:21: error: asm/xor.h: No such file or directory
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Jonas Bonn <jonas@southpole.se>

Acked-by: Jonas Bonn <jonas@southpole.se>

Feel free to take it via your tree for -rc5, as per your "exotic fixes" 
email.

Thanks,
Jonas

> ---
>   arch/openrisc/include/asm/Kbuild |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
> index f20d01d..195653e 100644
> --- a/arch/openrisc/include/asm/Kbuild
> +++ b/arch/openrisc/include/asm/Kbuild
> @@ -66,3 +66,4 @@ generic-y += types.h
>   generic-y += ucontext.h
>   generic-y += user.h
>   generic-y += word-at-a-time.h
> +generic-y += xor.h
>

