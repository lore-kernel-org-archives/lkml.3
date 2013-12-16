Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188Ab3LPF6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 00:58:04 -0500
Received: from mx9.pku.edu.cn ([162.105.129.172]:49678 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750781Ab3LPF6D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 00:58:03 -0500
X-Greylist: delayed 2527 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Dec 2013 00:58:02 EST
X-Spam-Flag: NO
X-Spam-Score: -308.123
Date: Mon, 16 Dec 2013 13:15:41 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, Guan Xuetao <gxt@mprc.pku.edu.cn>
Message-ID: <825885230.15108.1387170941161.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <1387040376-26906-9-git-send-email-msalter@redhat.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH_08/10]_unicore32:_s?=
 =?utf-8?Q?elect_ARCH=5FMIGHT=5FHAVE=5FPC=5FSERIO?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's ok to unicore32.

Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

----- Mark Salter <msalter@redhat.com> 写道：
> Architectures which might use an i8042 for serial IO to keyboard,
> mouse, etc should select ARCH_MIGHT_HAVE_PC_SERIO.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> CC: Guan Xuetao <gxt@mprc.pku.edu.cn>
> ---
>  arch/unicore32/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
> index a7ba27b..25c0dba 100644
> --- a/arch/unicore32/Kconfig
> +++ b/arch/unicore32/Kconfig
> @@ -1,6 +1,7 @@
>  config UNICORE32
>  	def_bool y
>  	select ARCH_MIGHT_HAVE_PC_PARPORT
> +	select ARCH_MIGHT_HAVE_PC_SERIO
>  	select HAVE_MEMBLOCK
>  	select HAVE_GENERIC_DMA_COHERENT
>  	select HAVE_DMA_ATTRS
> -- 
> 1.8.3.1
> 

