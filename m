Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3LXTiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 14:38:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36536 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab3LXTiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 14:38:07 -0500
Message-ID: <52B9E29B.1040005@infradead.org>
Date: Tue, 24 Dec 2013 11:38:03 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michal_Mal=FD?= <madcatxster@prifuk.cz>,
        linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org, elias.vds@gmail.com, joe@perches.com
Subject: Re: [RFC  v3] Add ff-memless-next
References: <1494187.y8mYFDm1lA@geidi-prime>
In-Reply-To: <1494187.y8mYFDm1lA@geidi-prime>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/13 14:46, Michal Malý wrote:
> ---
>  Documentation/input/ff-memless-next.txt | 145 ++++++
>  drivers/input/Kconfig                   |  12 +
>  drivers/input/Makefile                  |   2 +
>  drivers/input/ff-memless-next.c         | 786 ++++++++++++++++++++++++++++++++
>  include/linux/input/ff-memless-next.h   |  31 ++
>  5 files changed, 976 insertions(+)
>  create mode 100644 Documentation/input/ff-memless-next.txt
>  create mode 100644 drivers/input/ff-memless-next.c
>  create mode 100644 include/linux/input/ff-memless-next.h
> 
> diff --git a/Documentation/input/ff-memless-next.txt b/Documentation/input/ff-memless-next.txt
> new file mode 100644
> index 0000000..00f893d
> --- /dev/null
> +++ b/Documentation/input/ff-memless-next.txt
> @@ -0,0 +1,145 @@
> +"ff-memless-next" force feedback module for memoryless devices.
> +By Michal Malý <madcatxster@prifuk.cz> on 2013/12/21
> +----------------------------------------------------------------------------
> +
> +1. Introduction
> +~~~~~~~~~~~~~~~
> +This document describes basic working principles of the "ff-memless-next"

                                                                             driver
(or module)

> +and its purpose. This document also contains summary of "ff-memless-next" API

                                                a summary of the

> +and brief instructions on how to use it to write a hardware-specific backend
> +with "ff-memless-next". Some specifics of ff-memless-next that might be of
> +interest for userspace developers are also discussed.



> diff --git a/drivers/input/Kconfig b/drivers/input/Kconfig
> index a11ff74..893ab00 100644
> --- a/drivers/input/Kconfig
> +++ b/drivers/input/Kconfig
> @@ -77,6 +77,18 @@ config INPUT_MATRIXKMAP
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called matrix-keymap.
>  
> +config INPUT_FF_MEMLESS_NEXT
> +	tristate "New version of support for memoryless force feedback devices"
> +	help
> +	  Say Y here if you want to enable support for various memoryless
> +	  force feedback devices (as of now there is no hardware-specific
> +	  driver that supports this)

	                       this).

> +
> +	  If unsure, say N.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called ff-memless-next.
> +
>  comment "Userland interfaces"
>  
>  config INPUT_MOUSEDEV


-- 
~Randy
