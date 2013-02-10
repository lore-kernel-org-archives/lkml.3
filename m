Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab3BJRZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 12:25:34 -0500
Received: from mail.southpole.se ([37.247.8.11]:48944 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492Ab3BJRZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 12:25:33 -0500
Message-ID: <5117D818.1080407@southpole.se>
Date: Sun, 10 Feb 2013 18:25:44 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: linux-kernel@vger.kernel.org, linux@openrisc.net,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 1/1] openrisc: remove CONFIG_SYMBOL_PREFIX
References: <1360155488-12600-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1360155488-12600-1-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.2.2(12343) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 17128-07031
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/13 13:58, James Hogan wrote:
> Remove the SYMBOL_PREFIX Kconfig symbol as it's empty anyway.
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Jonas Bonn <jonas@southpole.se>
> Cc: linux@lists.openrisc.net
> Cc: Mike Frysinger <vapier@gentoo.org>
> ---
>   arch/openrisc/Kconfig |    4 ----
>   1 files changed, 0 insertions(+), 4 deletions(-)

Thanks, James.  Will apply.
/Jonas

>
> diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
> index 0ac66f6..35a4e5f 100644
> --- a/arch/openrisc/Kconfig
> +++ b/arch/openrisc/Kconfig
> @@ -26,10 +26,6 @@ config OPENRISC
>   config MMU
>   	def_bool y
>   
> -config SYMBOL_PREFIX
> -        string
> -        default ""
> -
>   config HAVE_DMA_ATTRS
>   	def_bool y
>   

